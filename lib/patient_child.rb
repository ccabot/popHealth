#
# This module is included by models that represent a subsection of a patient record.
#
module PatientChild
  def self.included(base)
    base.class_eval do
      belongs_to :patient
#      after_save { |r| p r.class; r._parent_document.update_attributes(:updated_at => Time.now) }
    end
  end
end
