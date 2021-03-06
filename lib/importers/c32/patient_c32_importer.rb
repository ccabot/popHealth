class PatientC32Importer
  
  def self.import_c32(clinical_document) 
    first_name_element = REXML::XPath.first(clinical_document, 
                                    "/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:given",
                                    {'cda' => 'urn:hl7-org:v3'})
    last_name_element = REXML::XPath.first(clinical_document, 
                                   "/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:family",
                                   {'cda' => 'urn:hl7-org:v3'})
    
    patient_name = first_name_element.text + " " + last_name_element.text
    
    if patient_name
      new_patient = Patient.new
      new_patient.name = patient_name
      
      registration_section = RegistrationInformationC32Importer.section(clinical_document)
      imported_info = RegistrationInformationC32Importer.import_entries(registration_section)
      new_patient.registration_information ||= imported_info.first
      
      allergy_section = AllergyC32Importer.section(clinical_document)
      imported_allergies = AllergyC32Importer.import_entries(allergy_section)
      new_patient.allergies << imported_allergies
      
      condition_section = ConditionC32Importer.section(clinical_document)
      imported_conditions = ConditionC32Importer.import_entries(condition_section)
      new_patient.conditions << imported_conditions
      
      medication_section = MedicationC32Importer.section(clinical_document)
      if medication_section
        imported_medications = MedicationC32Importer.import_entries(medication_section)
        new_patient.medications << imported_medications
      else
        medication = Medication.new
        medication.randomize()
        new_patient.medications << medication
      end
      
      immunization_section = ImmunizationC32Importer.section(clinical_document)
      if immunization_section
        imported_immunizations = ImmunizationC32Importer.import_entries(immunization_section)
        new_patient.immunizations << imported_immunizations
      else
        immunization = Immunization.new
        immunization.randomize(new_patient.registration_information.date_of_birth)
        new_patient.immunizations << immunization
      end
      
      vitals_section = VitalSignC32Importer.section(clinical_document)
      if vitals_section
        imported_vitals = VitalSignC32Importer.import_entries(vitals_section)
        new_patient.vital_signs << imported_vitals
      else
        vital_sign = VitalSign.new
        vital_sign.randomize(new_patient.registration_information.gender, new_patient.registration_information.date_of_birth, :systolic)
        new_patient.vital_signs << vital_sign

        vital_sign = VitalSign.new
        vital_sign.randomize(new_patient.registration_information.gender, new_patient.registration_information.date_of_birth, :diastolic)
        new_patient.vital_signs << vital_sign
      end
      
      result_section = ResultC32Importer.section(clinical_document)
      if result_section
        imported_results = ResultC32Importer.import_entries(result_section)
        new_patient.results << imported_results
      else
        result = Result.new
        result.randomize(new_patient.registration_information.gender, new_patient.registration_information.date_of_birth, :cholesterol)
        new_patient.results << result
        
        result = Result.new
        result.randomize(new_patient.registration_information.gender, new_patient.registration_information.date_of_birth, :LDL_C, imported_conditions)
        new_patient.results << result

        result = Result.new
        result.randomize(new_patient.registration_information.gender, new_patient.registration_information.date_of_birth, :colorectal_screening)
        new_patient.results << result

        result = Result.new
        result.randomize(new_patient.registration_information.gender, new_patient.registration_information.date_of_birth, :A1c, imported_conditions)
        new_patient.results << result
      end
      
      social_history_section = SocialHistoryC32Importer.section(clinical_document)
      if social_history_section
        imported_social_history = SocialHistoryC32Importer.import_entries(social_history_section)
        new_patient.social_history << imported_social_history
      else
        my_social_history = SocialHistory.new
        my_social_history.randomize(new_patient.registration_information.date_of_birth, imported_conditions)
        new_patient.social_history << my_social_history
      end
        
      new_patient.save!
    else
      false
    end
    
  end
  
end