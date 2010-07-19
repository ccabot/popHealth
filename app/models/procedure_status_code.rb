class ProcedureStatusCode
  include MongoMapper::Document

  extend RandomFinder
    has_select_options :label_column => :description,
                      :order => "description ASC"
    
end
