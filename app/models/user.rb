class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lastseenable

  has_many :memberships
  has_many :groups, through: :memberships
  has_many :invitations, class_name: 'Invite', foreign_key: 'recipient_id'
  has_many :sent_invites, class_name: 'Invite', foreign_key: 'sender_id'
  has_many :debts, class_name: 'Transaction', foreign_key: :debtor_id
  has_many :credits, class_name: 'Transaction', foreign_key: :creditor_id

  attr_accessor :invite_token

  scope :without, ->(user) { where.not(id: user) }

  validates :first_name, :last_name, :email, presence: true

  def name
    [first_name, last_name].merge_with(" ")
  end

  def avatar_url
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=200&d=monsterid"
  end

  def balance
    (credits.sum(:amount_cents) - debts.sum(:amount_cents)) / 100.0
  end
end
