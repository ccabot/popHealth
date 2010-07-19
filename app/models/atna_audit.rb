class AtnaAudit
  include MongoMapper::Document

  establish_connection "syslog"
  set_table_name "entry_element"
end
