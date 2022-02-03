class WindowsPhoneSms < ActiveRecord::Base
  self.table_name = 'windows_phone_smses'
  establish_connection :hindsight
end
