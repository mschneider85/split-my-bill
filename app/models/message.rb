class Message < ActiveRecord::Base
  belongs_to :conversation, touch: true
  belongs_to :user

  validates :body, :conversation_id, :user_id, presence: true
end
