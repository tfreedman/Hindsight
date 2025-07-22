class IphoneSms < ActiveRecord::Base
  establish_connection :hindsight
  self.table_name = 'iphone_smses'
end
