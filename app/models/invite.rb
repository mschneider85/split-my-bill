class Invite < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :group
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_create :generate_token
  before_validation :check_user_existence

  delegate :name, to: :group, prefix: true

  scope :pending, -> { where(accepted: nil) }
  scope :declined, -> { where(accepted: false) }
  scope :accepted, -> { where(accepted: true) }
  scope :for_sender, ->(user) { where(sender: user) }
  scope :for_recipient, ->(user) { where(recipient: user) }

  validates :email, presence: true, format: { with: Devise::email_regexp }
  validate do
    if (sender_id == recipient_id) || (group.users.ids.include? recipient_id)
      errors.add(:email, 'ist schon Mitglied dieser Gruppe')
    end
  end

  def accept!
    update_column(:accepted, true)
  end

  def decline!
    update_column(:accepted, false)
  end

  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.group_id, Time.now, rand].join)
  end

  def check_user_existence
    recipient = User.find_by(email: email)
    if recipient.present?
      self.recipient_id = recipient.id
    end
  end
end
