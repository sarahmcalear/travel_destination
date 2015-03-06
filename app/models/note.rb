class Note < ActiveRecord::Base
  belongs_to :destination
  has_one    :user, through: :destination

end
