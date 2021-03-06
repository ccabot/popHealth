class Result < AbstractResult

  def section_template_id
    '2.16.840.1.113883.10.20.1.14'
  end

  def statement_c32_template_id
    '2.16.840.1.113883.3.88.11.32.16'
  end

  def self.c32_component(results, xml)
    # Start Results
    unless results.empty?
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.14", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "30954-2", 
                   "displayName" => "Relevant diagnostic tests", 
                   "codeSystem" => "2.16.840.1.113883.6.1", 
                   "codeSystemName" => "LOINC")
          xml.title("Results")
          xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Result ID"
                  xml.th "Result Date"
                  xml.th "Result Display Name"
                  xml.th "Result Value"
                  xml.th "Result Unit"
                end
              end
              xml.tbody do
                results.each do |result|
                  xml.tr do 
                    xml.td do
                      xml.content(result.result_id, "ID" => "result-#{result.result_id}")
                    end
                    xml.td(result.result_date)
                    xml.td(result.result_code_display_name)
                    xml.td(result.value_scalar)
                    xml.td(result.value_unit)
                  end
                end
              end
            end
          end
          yield
        end
      end
    end
    # End Results
  end
  
  def randomize(gender, birthdate, result, conditions = nil)
    self.result_id = rand(100).to_s + 'd' + rand(100000).to_s + '-bd' + 
                     rand(100).to_s + '-4c90-891d-eb716d' + rand(10000).to_s + 'c4'
    self.result_date = DateTime.new(2000 + rand(9), rand(12) + 1, rand(28) + 1)
    # sets code system as LOINC
    self.code_system = CodeSystem.find_by_code("2.16.840.1.113883.6.1") 
    self.status_code = 'N'
    case result
    when :cholesterol
      self.value_unit = 'mg/dL'
      self.result_code_display_name = 'LDL Cholesterol'
      self.result_code = '18261-8'
      p = rand
      if p < 0.25
        self.value_scalar = rand_range(80, 100)
      elsif p < 0.5 
        self.value_scalar = rand_range(100, 130)
      elsif p < 0.75
        self.value_scalar = rand_range(130, 160)
      elsif p < 0.9
        self.value_scalar = rand_range(160, 190)
      else
        self.value_scalar = rand_range(190, 210)
      end
    when :colorectal_screening
      #Colorectal Cancer Screening
      age = Date.today.year - birthdate.year
      if  age > 50
        p = rand
        if p < 0.42
          self.result_code_display_name = 'Colorectal Cancer Screening'
          self.result_code = '54047-6'
        end
      end
    when :A1c
      #hemoglobin A1c
      if conditions
        conditions.try(:each) do |condition|
          if condition.free_text_name == "Diabetes mellitus disorder"
            @diabetes = true
          end
        end
      end
      if @diabetes
        self.value_unit = '%'
        self.result_code_display_name = 'HbA1c'
        self.result_code = '54039-3'
        p = rand
        if p < 0.10
          self.value_scalar = rand_range(0, 7)
        elsif p < 0.60
          self.value_scalar = rand_range(7, 9)
        else
          self.value_scalar = rand_range(9, 18)
        end
      end
    when :LDL_C
      self.value_unit = 'mg/dL'
      self.result_code_display_name = 'LDL-C'
      self.result_code = '54040-1'
      p = rand
      if p < 0.40
        self.value_scalar = rand_range(80, 100)
      elsif p < 0.25
        self.value_scalar = rand_range(100, 130)
      elsif p < 0.20
        self.value_scalar = rand_range(130, 160)
      else 
        self.value_scalar = rand_range(160, 210)
      end
    end
  end

end