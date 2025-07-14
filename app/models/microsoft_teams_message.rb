class MicrosoftTeamsMessage < ActiveRecord::Base
  establish_connection :hindsight

  serialize :properties
  serialize :ams_references
end
