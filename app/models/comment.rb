class Comment
  include MongoMapper::Document



  belongs_to :commentable, :polymorphic => true

  after_save {|r| r.commentable.patient.update_attributes(:updated_at => DateTime.now) }

  def to_c32(xml)

  end

  def randomize()
    self.text = 'Patient is very healthy'
  end

end
