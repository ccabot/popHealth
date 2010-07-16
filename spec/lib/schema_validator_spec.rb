require File.dirname(__FILE__) + '/../spec_helper'

# commented out 2010-07-15 ccabot because it looks as if this code
# depends on config/initializers/laika_validation.rb which lives in
# laika but not in this project.  FIXME we shoule either remove this
# file entirely or move the necessary stuff from laika to popHealth to
# make this work.

# describe Validators::Schema::Validator, "can validate xml against a schema" do

#   it "should validate document as conforming to schema"  do
    
#      xml = File.open(File.dirname(__FILE__) + "/../test_data/validators/addressbook_id.xml","r") do |f| f.read() end
#      processor = Validators::Schema::Validator.new("something",File.dirname(__FILE__) + "/../test_data/validators/addressbook_id.xsd")
#      processor.validate(nil,REXML::Document.new(xml)).should be_empty
#   end

#   it "should not validate document not in conformance to the schema file"  do     
#      xml = File.open(File.dirname(__FILE__) + "/../test_data/validators/addressbook_id_bad.xml","r") do |f| f.read() end
#      processor = Validators::Schema::Validator.new("something",File.dirname(__FILE__) + "/../test_data/validators/addressbook_id.xsd")
#      processor.validate(nil,REXML::Document.new(xml)).should_not be_empty
#   end


# end
