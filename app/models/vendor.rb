class Vendor < ActiveRecord::Base
  has_select_options(:order => 'user_id ASC, public_id ASC') {|r| [ r.public_id, r.id ] }

  belongs_to :user
  attr_protected :user
  validates_presence_of :public_id, :user_id
  validates_uniqueness_of :public_id, :scope => :user_id, :message => 'name is already in use.'

  def to_s
    public_id
  end

  def editable_by?(vendor_user)
    user == vendor_user
  end
end
