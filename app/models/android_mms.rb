class AndroidMms < ActiveRecord::Base
  self.table_name = 'android_mmses'
  establish_connection :hindsight
end
