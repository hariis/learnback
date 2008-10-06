class Comment < ActiveRecord::Base
  belongs_to :opinion
  belongs_to :user
  
  validates_presence_of :body
end
