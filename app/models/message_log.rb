class MessageLog
  include MongoMapper::Document

  MongoMapper.database = "messagelog"
end
