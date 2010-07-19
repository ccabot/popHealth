class LanguageAbilityMode
  include MongoMapper::Document

  extend RandomFinder
  has_select_options
end
