class Vaccine
  include MongoMapper::Document

  extend RandomFinder
  has_select_options

  key :code
  key :name

  def to_c32(xml)
    xml.code('code' => code, 
             'codeSystem' => '2.16.840.1.113883.6.59',
             'displayName' => name) do
      xml.originalText name	
    end
  end

end
