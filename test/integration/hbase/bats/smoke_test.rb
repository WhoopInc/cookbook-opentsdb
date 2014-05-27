begin
  include Java

  import org.apache.hadoop.hbase.HBaseConfiguration
  import org.apache.hadoop.hbase.HColumnDescriptor
  import org.apache.hadoop.hbase.HTableDescriptor
  import org.apache.hadoop.hbase.client.Get
  import org.apache.hadoop.hbase.client.HBaseAdmin
  import org.apache.hadoop.hbase.client.HTable
  import org.apache.hadoop.hbase.client.Put
  import org.apache.hadoop.hbase.util.Bytes

  TABLE_NAME = 'test'.to_java_bytes
  FAMILY_NAME = 'family'.to_java_bytes

  ROW_NAME = 'row'.to_java_bytes
  COLUMN_NAME = 'big'.to_java_bytes
  VALUE = 'data'.to_java_bytes

  conf = HBaseConfiguration.new
  admin = HBaseAdmin.new(conf)

  table_desc = HTableDescriptor.new(TABLE_NAME)
  table_desc.add_family(HColumnDescriptor.new(FAMILY_NAME))
  admin.create_table(table_desc)

  fail 'table not created' unless admin.table_exists(TABLE_NAME)

  table = HTable.new(conf, TABLE_NAME)

  put = Put.new(ROW_NAME)
  put.add(FAMILY_NAME, COLUMN_NAME, VALUE)
  table.put(put)

  get = Get.new(ROW_NAME)
  result = table.get(get)
  value = result.get_value(FAMILY_NAME, COLUMN_NAME)

  fail 'value not saved' unless Bytes.equals(VALUE, value)
ensure
  admin.disable_table(TABLE_NAME) rescue nil
  admin.delete_table(TABLE_NAME) rescue nil
end
