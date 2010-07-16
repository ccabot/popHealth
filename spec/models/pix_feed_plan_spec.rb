require File.dirname(__FILE__) + '/../spec_helper'

# commented out 2010-07-15 ccabot because it looks as if this code
# depends on config/initializers/laika_validation.rb which lives in
# laika but not in this project.  FIXME we shoule either remove this
# file entirely or move the necessary stuff from laika to popHealth to
# make this work.

# describe PixFeedPlan do
#   it "should set and get expected PatientIdentifier" do
#     plan = PixFeedPlan.factory.create
#     pi   = PatientIdentifier.new :patient_identifier => 'foo',
#                                  :affinity_domain => 'bar'

#     plan.expected = pi
#     plan.expected.class.name.should == 'PatientIdentifier'
#     plan.matches_expected?(pi).should be_true
#   end
# end

