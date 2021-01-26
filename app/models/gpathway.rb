class Gpathway < ApplicationRecord
   belongs_to :user
   has_many :greactions, dependent: :destroy
   
   with_options presence: true do
      validates :title 
      validates :description 
   end
end
