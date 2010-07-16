require File.dirname(__FILE__) + '/../spec_helper'

# commented out 2010-07-15 ccabot because it looks as if this code
# depends on config/initializers/laika_validation.rb which lives in
# laika but not in this project.  FIXME we shoule either remove this
# file entirely or move the necessary stuff from laika to popHealth to
# make this work.

# describe InsuranceProviderPatientsController do
#   before do
#     @patient = Patient.factory.create
#     controller.stub!(:current_user).and_return(@patient.user)
#   end

#   it "should render edit template on get edit" do
#     get :edit, :patient_id => @patient.id.to_s, :id => @patient.insurance_provider_patients.first.id.to_s
#     response.should render_template('insurance_provider_patients/edit')
#   end

#   it "should assign @insurance_provider_patient on get edit" do
#     get :edit, :patient_id => @patient.id.to_s, :id => @patient.insurance_provider_patients.first.id.to_s
#     assigns[:insurance_provider_patient].should == @patient.insurance_provider_patients.first
#   end

#   it "should render show partial on put update" do
#     put :update, :patient_id => @patient.id.to_s, :id => @patient.insurance_provider_patients.first.id.to_s
#     response.should render_template('insurance_provider_patients/_show')
#   end

#   it "should update insurance_provider_patient on put update" do
#     existing_insurance_provider_patient = @patient.insurance_provider_patients.first
#     put :update, :patient_id => @patient.id.to_s, :id => existing_insurance_provider_patient.id.to_s,
#       :insurance_provider_patient => { :member_id => 'foobar' }
#     existing_insurance_provider_patient.reload
#     existing_insurance_provider_patient.member_id.should == 'foobar'
#   end

# end

