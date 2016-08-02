class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }
  validate :check_if_sender_is_recipient

  scope :between, -> (sender_id, recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?)", sender_id, recipient_id, recipient_id, sender_id)
  end

  private

  def check_if_sender_is_recipient
    errors.add(:base, 'Du kannst dir selbst keine Nachrichten schicken') if sender_id == recipient_id
  end
end
