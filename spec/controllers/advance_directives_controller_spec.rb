require File.dirname(__FILE__) + '/../spec_helper'

# commented out 2010-07-15 ccabot because it looks as if this code
# depends on config/initializers/laika_validation.rb which lives in
# laika but not in this project.  FIXME we shoule either remove this
# file entirely or move the necessary stuff from laika to popHealth to
# make this work.

# describe AdvanceDirectivesController do
#   before do
#     @patient = Patient.factory.create
#     controller.stub!(:current_user).and_return(@patient.user)
#   end

#   it "should update comment record" do
#     put :update, :patient_id => @patient.id.to_s,
#       :advance_directive => { :comment_attributes => { :text => 'roberts' } }
#     @patient.advance_directive.comment.text.should == 'roberts'
#   end

#   it "should render edit template on get new" do
#     get :new, :patient_id => @patient.id.to_s
#     response.should render_template('advance_directives/edit')
#   end

#   it "should assign @advance_directive on get new" do
#     get :new, :patient_id => @patient.id.to_s
#     assigns[:advance_directive].should be_new_record
#   end

#   it "should render edit template on get edit" do
#     get :edit, :patient_id => @patient.id.to_s
#     response.should render_template('advance_directives/edit')
#   end

#   it "should assign @advance_directive on get edit" do
#     get :edit, :patient_id => @patient.id.to_s
#     assigns[:advance_directive].should == @patient.advance_directive
#   end

#   it "should render show partial on post create" do
#     post :create, :patient_id => @patient.id.to_s
#     response.should render_template('advance_directives/_show')
#   end

#   it "should not assign @advance_directive on post create" do
#     post :create, :patient_id => @patient.id.to_s
#     assigns[:advance_directive].should be_nil
#   end

#   it "should render show partial on put update" do
#     put :update, :patient_id => @patient.id.to_s
#     response.should render_template('advance_directives/_show')
#   end

#   it "should not assign @advance_directive on put update" do
#     put :update, :patient_id => @patient.id.to_s
#     assigns[:advance_directive].should be_nil
#   end

#   it "should render show partial on delete destroy" do
#     delete :destroy, :patient_id => @patient.id.to_s
#     response.should render_template('advance_directives/_show')
#   end

#   it "should not assign @advance_directive on delete destroy" do
#     delete :destroy, :patient_id => @patient.id.to_s
#     assigns[:advance_directive].should be_nil
#   end

#   it "should unset @patient.advance_directive on delete destroy" do
#     delete :destroy, :patient_id => @patient.id.to_s
#     @patient.reload
#     @patient.advance_directive.should be_nil
#   end

# end

