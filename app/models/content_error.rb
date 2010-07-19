class ContentError
  include MongoMapper::Document

  belongs_to :test_plan
end
