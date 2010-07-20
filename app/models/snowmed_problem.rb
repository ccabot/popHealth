class SnowmedProblem
  include MongoMapper::Document
  extend RandomFinder

  key :code
  key :name
end
