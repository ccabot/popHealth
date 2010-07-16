require File.dirname(__FILE__) + '/../spec_helper'

# commented out 2010-07-15 ccabot because it looks as if this code
# depends on config/initializers/laika_validation.rb which lives in
# laika but not in this project.  FIXME we shoule either remove this
# file entirely or move the necessary stuff from laika to popHealth to
# make this work.

# describe InsuranceProviderGuarantorsController do
#   before do
#     @patient = Patient.factory.create
#     controller.stub!(:current_user).and_return(@patient.user)
#   end

#   it "should render edit template on get edit" do
#     get :edit, :patient_id => @patient.id.to_s, :id => @patient.insurance_provider_guarantors.first.id.to_s
#     response.should render_template('insurance_provider_guarantors/edit')
#   end

#   it "should assign @insurance_provider_guarantor on get edit" do
#     get :edit, :patient_id => @patient.id.to_s, :id => @patient.insurance_provider_guarantors.first.id.to_s
#     assigns[:insurance_provider_guarantor].should == @patient.insurance_provider_guarantors.first
#   end

#   it "should render show partial on put update" do
#     put :update, :patient_id => @patient.id.to_s, :id => @patient.insurance_provider_guarantors.first.id.to_s
#     response.should render_template('insurance_provider_guarantors/_show')
#   end

#   it "should update insurance_provider_guarantor on put update" do
#     sentinel_date = Date.today
#     existing_insurance_provider_guarantor = @patient.insurance_provider_guarantors.first
#     put :update, :patient_id => @patient.id.to_s, :id => existing_insurance_provider_guarantor.id.to_s,
#       :insurance_provider_guarantor => { :effective_date => sentinel_date }
#     existing_insurance_provider_guarantor.reload
#     existing_insurance_provider_guarantor.effective_date.should == sentinel_date
#   end

# end

