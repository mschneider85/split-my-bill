class Invite < ActiveRecord::Base
  belongs_to :group
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_create :generate_token
  before_save :check_user_existence

  delegate :name, to: :group, prefix: true

  scope :pending, -> { where(accepted: false) }

  def accept!
    self.accepted = true
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
