class AndroidSms < ActiveRecord::Base
  self.table_name = 'android_smses'
  establish_connection :hindsight
end
