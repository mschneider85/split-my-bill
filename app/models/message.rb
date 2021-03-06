class Message < ActiveRecord::Base
  belongs_to :conversation, touch: true
  belongs_to :user

  scope :unread, -> { where(read: false) }
  scope :unread_for, ->(user) { where(read: false).where.not(user: user) }

  validates :body, :conversation_id, :user_id, presence: true
end
