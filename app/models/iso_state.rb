class IsoState
  include MongoMapper::Document

  extend RandomFinder
  has_select_options(:order => 'iso_abbreviation ASC') {|r| r.iso_abbreviation }
end
