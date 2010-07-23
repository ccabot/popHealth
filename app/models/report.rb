class Report
  include MongoMapper::Document

  key :numerator_query
  key :denominator_query
  key :title

  attr_accessor :numerator_request
  attr_accessor :numerator
  attr_accessor :denominator

  def numerator_hash
    YAML.load(@numerator_query)
  end

  def denominator_hash
    YAML.load(@denominator_query)
  end

  def numerator_hash=(raw)
    @numerator_query = YAML.dump(raw)
  end

  def denominator_hash=(raw)
    @denominator_query = YAML.dump(raw)
  end

  def to_json_hash
    {:title => self.title,  :numerator => self.numerator, :denominator => self.denominator, :id => self.id,
      :numerator_fields => self.numerator_hash, :denominator_fields => self.denominator_hash}
  end
  
  def to_json(*args)
    to_json_hash.to_json
  end
  
  
  def self.patient_count 
    return @@patient_count || 0
  end
  
  def self.create_and_populate(params)
    load_static_content
    
    if params[:id].blank? && (params[:numerator].present? || params[:denominator].present? || params[:title].present?)
      report = Report.new
      report.numerator_hash = params[:numerator] || {}
      report.denominator_hash = params[:denominator] || {}
      report.title = params[:title] || "Untitled Report"
      if !params[:denominator].blank? 
        report.denominator = count_patients(report.denominator_hash)
      else
        report.denominator = @@patient_count
      end
      # @report.save <-- right now this just has the effect of saving the first change and nothing afterwards
    # create a blank report but don't save  
    elsif params[:id].blank? && params[:numerator].blank? && params[:denominator].blank? && params[:title].blank? 
      report = Report.new
      report.numerator_hash =  {}
      report.denominator_hash = {}
      report.denominator = @@patient_count
      report.title = "Untitled Report"
    elsif params[:id] # update an existing report
      report = find(params[:id])
      report.numerator_hash = params[:numerator] || {}
      report.denominator_hash = params[:denominator] || {}
      report.title = params[:title] if params[:title]
      report.denominator = count_patients(report.denominator_hash)
    end
    
    # only run the numerator query if there are any fields provided
    if report.numerator_hash.size > 0
      report.numerator = count_patients(merge_popconnect_request(report.denominator_hash, report.numerator_hash))
    else
      report.numerator = 0
    end
    
    return report
  end
  
  def self.all_and_populate(options = {})
    reports = all(options)
    load_static_content
    reports.each do |item|
       item.denominator = (count_patients(item.denominator_hash))
        # only run the numerator query if there are any fields provided
        if item.numerator_query.size > 0
          item.numerator = count_patients(merge_popconnect_request(item.denominator_hash,
                                                                            item.numerator_hash))
        else
          item.numerator = 0
        end
        item.save!
    end
    
    return reports
  end
  
  
  def self.load_static_content
    @@patient_count = Patient.count
    @@male = Gender.find_by_code('M')
    @@female = Gender.find_by_code('F')
    @@tobacco_use_and_exposure = SocialHistoryType.find_by_name("Tobacco use and exposure")
    @@valid_parameters = [:gender, :age, :medications, :blood_pressures, 
                           :therapies, :diabetes, :smoking, :hypertension, 
                           :ischemic_vascular_disease, :lipoid_disorder, 
                           :ldl_cholesterol, :colorectal_cancer_screening,
                           :mammography, :influenza_vaccine, :hb_a1c]
  end
  
  def self.find_and_populate(id)
    report = find(id)
    
    if report == nil
      return nil
    end
    
    load_static_content
    
    report.denominator = (count_patients(report.denominator_hash))
      # only run the numerator query if there are any fields provided
    if report.numerator_query.size > 0
      temp_request = merge_popconnect_request(report.denominator_hash, report.numerator_hash)
      report.numerator = count_patients(temp_request)
      report.numerator_request = temp_request
    else
      report.numerator = 0
    end
    return report
  end
  
  def self.find_and_generate_patients_query(id)
      report = find_and_populate(id)
      if report.nil?
        return nil
      end
      return generate_population_query(report.numerator_request)
  end
  
  def self.count_patients(report_request, load = false)
    if load
      load_static_content
    end
    Patient.count(generate_population_query(report_request))
  end
   # this merge is a little bit specialized, since it will do a careful merge of the values in
   # the hashs' arrays, where there will be no duplicate entries in the arrays, and no entries
   # will be deleted with the merge
   def self.merge_popconnect_request(hash1, hash2)
     resp = {}
     @@valid_parameters.each do |next_parameter|
       if (hash1.has_key?(next_parameter) || hash2.has_key?(next_parameter))
         resp[next_parameter] = merge_values(hash1, hash2, next_parameter)
       end
     end
     resp
   end

   def self.merge_values(hash1, hash2, key)
     merged_values = Array.new()
     # only hash 1 has key, and hash 2 does not
     if (hash1.has_key?(key) && !hash2.has_key?(key))
       merged_values = hash1[key]
     # only hash 2 has key, and hash 1 does not
     elsif (!hash1.has_key?(key) && hash2.has_key?(key))
       merged_values = hash2[key]
     # both hash 1 has key, and hash 2 has key
     elsif (hash1.has_key?(key) && hash2.has_key?(key))
       merged_values = (hash1[key]) + (hash2[key])
       merged_values = merged_values.uniq
     end
     merged_values
   end
   
   
   def self.generate_population_query(request)
     query_conditions = {}
     query_js = []

     # FIXME 2010-07-22 ccabot this can probably be coded to use conditions instead of JS
     if request.has_key?(:gender)
       gender_clauses = []
       request[:gender].each do |next_gender_query|
         next_gender_query == "Female" &&
           gender_clauses << "this.registration_information.gender_id=='#{@@female.id}'"
         next_gender_query == "Male" &&
           gender_clauses << "this.registration_information.gender_id=='#{@@male.id}'"
       end
       query_js << "( #{gender_clauses.join '||'} )"
     end

     if request.has_key?(:age)
       ranges = []
       request[:age].each do |next_age_query|
         if next_age_query == "<18"
           ranges << {"registration_information.date_of_birth" => {'$gt' => 18.years.ago}}
         end
         if next_age_query == "18-30"
           ranges << {"registration_information.date_of_birth" => {'$gt' => 30.years.ago, '$lt' => 18.years.ago}}
         end
         if next_age_query == "30-40"
           ranges << {"registration_information.date_of_birth" => {'$gt' => 40.years.ago, '$lt' => 30.years.ago}}
         end
         # mongdb hates old people!  they store date in an unsigned so
         # you can't query for dates older than the unix epoch.
         # really: http://jira.mongodb.org/browse/SERVER-405
         if next_age_query == "40-50"
           ranges << {"registration_information.date_of_birth" => {'$gt' => 50.years.ago, '$lt' => 40.years.ago}}
         end
         if next_age_query == "50-60"
           ranges << {"registration_information.date_of_birth" => {'$gt' => 60.years.ago, '$lt' => 50.years.ago}}
         end
         if next_age_query == "60-70"
           ranges << {"registration_information.date_of_birth" => {'$gt' => 70.years.ago, '$lt' => 60.years.ago}}
         end
         if next_age_query == "70-80"
           ranges << {"registration_information.date_of_birth" => {'$gt' => 80.years.ago, '$lt' => 70.years.ago}}
         end
         if next_age_query == "80+"
           ranges << {"registration_information.date_of_birth" => {'$lt' => 80.years.ago}}
         end
       end
       !ranges.empty? && query_conditions.merge!({'$or' => ranges})
     end

     if request.has_key?(:therapies) && request[:therapies].include?("Smoking Cessation")
       query_conditions.merge! 'social_history.social_history_type_id' => @@tobacco_use_and_exposure.id
     end

     if request.has_key?(:diabetes)
       if request[:diabetes].include?("Yes")
         query_conditions.merge! 'conditions.free_text_name' => /^Diabetes mellitus/
       end
       if request[:diabetes].include?("No")
         query_conditions.merge! 'conditions.free_text_name' => {'$not' => /^Diabetes mellitus/}
       end
     end

     if request.has_key?(:hypertension)
       if request[:hypertension].include?("Yes")
         query_conditions.merge! 'conditions.free_text_name' => /hypertension disorder/
       end
       if request[:hypertension].include?("No")
         query_conditions.merge! 'conditions.free_text_name' => {'$not' => /hypertension disorder/}
       end
     end

     if request.has_key?(:ischemic_vascular_disease)
       if request[:ischemic_vascular_disease].include?("Yes")
         query_conditions.merge! 'conditions.free_text_name' => /^Ischemia /
       end
       if request[:ischemic_vascular_disease].include?("No")
         query_conditions.merge! 'conditions.free_text_name' => {'$not' => /^Ischemia /}
       end
     end

     if request.has_key?(:lipoid_disorder)
       if request[:lipoid_disorder].include?("Yes")
         query_conditions.merge! 'conditions.free_text_name' => /^Hyperlipoproteinemia /
       end
       if request[:lipoid_disorder].include?("No")
         query_conditions.merge! 'conditions.free_text_name' => {'$not' => /^Hyperlipoproteinemia /}
       end
     end

     if request.has_key?(:smoking)
       if request[:smoking].include?("Current Smoker")
         query_conditions.merge! 'conditions.free_text_name' => /^Smoker /
       end
       if request[:smoking].include?("Non-Smoker")
         query_conditions.merge! 'conditions.free_text_name' => {'$not' => /^Smoker /}
       end
     end

     if request.has_key?(:medications)
       medications = request[:medications]
       medications.each do |next_medication|
         if next_medication == "Aspirin"
           query_conditions.merge! 'medications.product_code' => 'R16CO5Y76E'
         end
       end
     end

     if request.has_key?(:blood_pressures)
       ranges = []
       request[:blood_pressures].each do |next_bp_query|
         if next_bp_query == "110/70"
           ranges << {"value_scalar" => {'$lt' => 75}}
         end
         if next_bp_query == "120/80"
           ranges << {"value_scalar" => {'$gte' => 75, '$lt' => 85}}
         end
         if next_bp_query == "140/90"
           ranges << {"value_scalar" => {'$gte' => 85, '$lt' => 95}}
         end
         if next_bp_query == "160/100"
           ranges << {"value_scalar" => {'$gte' => 95, '$lt' => 105}}
         end
         if next_bp_query == "180/110+"
           ranges << {"value_scalar" => {'$gte' => 105}}
         end
       end
       if !ranges.empty?
         query_conditions.merge!({'vital_signs'=> {'$elemMatch'=> {'result_code' => '8462-4', '$or' => ranges}}})
       end
     end

     if request.has_key?(:ldl_cholesterol)
       ranges = []
       request[:ldl_cholesterol].each do |next_ldl_query|
         if next_ldl_query == "100"
           ranges << {"value_scalar" => {'$lt' => 101}}
         elsif next_ldl_query == "100-120"
           ranges << {"value_scalar" => {'$gte' => 101, '$lt' => 121}}
         elsif next_ldl_query == "130-160"
           ranges << {"value_scalar" => {'$gte' => 131, '$lt' => 161}}
         elsif next_ldl_query == "160-180"
           ranges << {"value_scalar" => {'$gte' => 161, '$lt' => 181}}
         elsif next_ldl_query == "180+"
           ranges << {"value_scalar" => {'$gte' => 181}}
         end
       end
       if !ranges.empty?
         bp_conditions =
         query_conditions.merge!({'results'=> {'$elemMatch'=> {'result_code' => '18261-8', '$or' => ranges}}})
       end
     end

     if request.has_key?(:colorectal_cancer_screening)
       if request[:colorectal_cancer_screening].include?("Yes")
         query_conditions.merge! 'results.result_code' => '54047-6'
       end
       if request[:colorectal_cancer_screening].include?("No")
         query_conditions.merge! 'results.result_code' => {'$not' => /^54047-6$/}
       end
     end

     if request.has_key?(:mammography)
       if request[:mammography].include?("Yes")
         query_conditions.merge! 'conditions.free_text_name' => { '$in' => [/Mammographic breast mass finding/, /Mammography abnormal finding/, /Mammography assessment Category 3    Probably benign finding short interval follow up finding/, /Mammography normal finding/]}
       end
       if request[:mammography].include?("No")
         query_conditions.merge! 'conditions.free_text_name' => {'$nin' => [/Mammographic breast mass finding/, /Mammography abnormal finding/, /Mammography assessment Category 3    Probably benign finding short interval follow up finding/, /Mammography normal finding/]}
       end
     end

     if request.has_key?(:influenza_vaccine)
       flu_vac = Vaccine.first 'name' => /^Influenza Virus Vaccine/
       if request[:influenza_vaccine].include?("Yes")
         query_conditions.merge! 'immunizations.vaccine_id' => flu_vac.id
       end
       if request[:influenza_vaccine].include?("No")
         query_conditions.merge! 'immunizations.vaccine_id' => {'$nin' => [flu_vac.id]}
       end
     end

     if request.has_key?(:hb_a1c)
       ranges = []
       request[:hb_a1c].each do |next_hb_a1c_query|
         if next_hb_a1c_query == "<7"
           ranges << {"value_scalar" => {'$lt' => 7}}
         elsif next_hb_a1c_query == "7-8"
           ranges << {"value_scalar" => {'$gte' => 7, '$lt' => 9}}
         elsif next_hb_a1c_query == "8-9"
           ranges << {"value_scalar" => {'$gte' => 8, '$lt' => 10}}
         elsif next_hb_a1c_query == "9+"
           ranges << {"value_scalar" => {'$gte' => 9}}
         end
       end
       if !ranges.empty?
         query_conditions.merge!({'results'=> {'$elemMatch'=> {'result_code' => '54039-3', '$or' => ranges}}})
       end
     end

     query_conditions.merge!('$where' => query_js.join('&&')) if !query_js.empty?
     query_conditions
   end



  # Build a PQRI document representing the report.
  #
  # @return [Builder::XmlMarkup] PQRI representation of report data
  def to_pqri(pqri_xml = nil)
    pqri_xml ||= Builder::XmlMarkup.new(:indent => 2)
    pqri_xml.submission("type" => "PQRI-REGISTRY", "option" => "PAYMENT", "version" => "1.0",
    "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
    "xsi:noNamespaceSchemaLocation" => "Registry_Payment.xsd") {

      pqri_xml.tag!('file-audit-data') {
        pqri_xml.tag! :'create-date', DateTime.now.strftime("%m-%d-%Y")
        pqri_xml.tag! :'create-time', DateTime.now.strftime("%H:%M")
        pqri_xml.tag! :'create-by', "popHealth"
        pqri_xml.tag! :version, "1.0"
        pqri_xml.tag! :'file-number', "1"
        pqri_xml.tag! :'number-of-files', "1"
      }

      pqri_xml.registry {
        pqri_xml.tag! :'registry-name', "Example Registry"
        pqri_xml.tag! :'registry-id', "000-exampleRegistryId"
        pqri_xml.tag! :'submission-period-from-date', "01-01-2009"
        pqri_xml.tag! :'submission-period-to-date', DateTime.now.strftime("%m-%d-%Y")
        pqri_xml.tag! :'submission-method', "A"
      }

      pqri_xml.tag! :'measure-group', "ID" => "X" do
        pqri_xml.provider {
          pqri_xml.npi("1234567890")
          pqri_xml.tin("Tax Id #")
          pqri_xml.tag! :'waiver-signed', "Y"
          pqri_xml.tag! :'pqri-measure' do
            pqri_xml.tag! :'pqri-measure-number', self.id.to_s + "-" + self.title 
            pqri_xml.tag! :'eligible-instances', self.denominator
            pqri_xml.tag! :'meets-performance-instances', self.numerator
            pqri_xml.tag! :'performance-exclusion-instances', 0
            pqri_xml.tag! :'performance-not-met-instances', (self.denominator - self.numerator)
            pqri_xml.tag! :'reporting-rate', "100.00"
            pqri_xml.tag! :'performance-rate', "%.2f" % (Float.induced_from(self.numerator) / Float.induced_from(self.denominator) * 100)
          end
        }
      end
    }
  end

end
