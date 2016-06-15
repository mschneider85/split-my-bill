class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :debts, through: :user
  has_many :credits, through: :user

  validates :user, uniqueness: { scope: :group }

  def balance
    (credits.sum(:amount_cents) - debts.sum(:amount_cents)) / 100.0
  end
end
