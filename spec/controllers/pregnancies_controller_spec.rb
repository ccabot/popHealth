require File.dirname(__FILE__) + '/../spec_helper'

# commented out 2010-07-15 ccabot because it looks as if this code
# depends on config/initializers/laika_validation.rb which lives in
# laika but not in this project.  FIXME we shoule either remove this
# file entirely or move the necessary stuff from laika to popHealth to
# make this work.

# describe PregnanciesController do
#   before do
#     controller.stub!(:current_user).and_return(stub_model User)
#   end

#   it "should display the edit page" do
#     pd = Patient.factory.create(:pregnant => false)
#     controller.stub!(:current_user).and_return(pd.user)

#     get :edit, :patient_id => pd.id.to_s

#     assigns[:patient].should == pd
#     response.should render_template("pregnancies/edit")
#     response.layout.should be_nil
#   end

#   it "should update patients with pregnancy on" do
#     pd = Patient.factory.create(:pregnant => false)
#     controller.stub!(:current_user).and_return(pd.user)

#     put :update, :patient_id => pd.id.to_s, :pregnant => 'on'

#     pd.reload
#     pd.pregnant.should == true
#   end

#   it "should update patients with pregnancy off" do
#     pd = Patient.factory.create(:pregnant => true)
#     controller.stub!(:current_user).and_return(pd.user)

#     put :update, :patient_id => pd.id.to_s

#     pd.reload
#     pd.pregnant.should == false
#   end

#   it "should update pregnant patient with pregnancy nil" do
#     pd = Patient.factory.create(:pregnant => true)
#     controller.stub!(:current_user).and_return(pd.user)

#     delete :destroy, :patient_id => pd.id.to_s

#     pd.reload
#     pd.pregnant.should be_nil
#   end

#   it "should update non-pregnant patient with pregnancy nil" do
#     pending "SF ticket 2783842"

#     pd = Patient.factory.create(:pregnant => false)
#     controller.stub!(:current_user).and_return(pd.user)

#     delete :destroy, :patient_id => pd.id.to_s

#     pd.reload
#     pd.pregnant.should be_nil
#   end

# end
