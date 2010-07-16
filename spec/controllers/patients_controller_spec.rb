require File.dirname(__FILE__) + '/../spec_helper'

describe PatientsController do

  before(:each) do
    @user = User.factory.create
    controller.stub!(:current_user).and_return(@user)
  end

  # pretty minimal now, just exercises the code, in case of crashes
  it "should show user" do
    pd_mock = mock('pd')
    pd_mock.stub!(:to_c32).and_return('<ClinicalDocument/>')
    pd_mock.stub!(:test_plan_id).and_return(nil)
    pd_mock.stub!(:id).and_return(7)
    pd_mock.stub!(:name).and_return('Name')
    Patient.stub!(:find).and_return(pd_mock)
    get :show, :id => 1, :format => 'xml'
  end

end
