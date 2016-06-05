class Invite < ActiveRecord::Base
  belongs_to :group
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_create :generate_token
  before_save :check_user_existence

  delegate :name, to: :group, prefix: true

  scope :pending, -> { where(accepted: nil) }
  scope :declined, -> { where(accepted: false) }
  scope :accepted, -> { where(accepted: true) }
  scope :for_sender, ->(user) { where(sender: user) }
  scope :for_recipient, ->(user) { where(recipient: user) }

  def accept!
    self.accepted = true
    self.save
  end

  def decline!
    self.accepted = false
    self.save
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
