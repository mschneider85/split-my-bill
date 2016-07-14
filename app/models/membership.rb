class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :user, uniqueness: { scope: :group }

  def debts
    user.debts.includes(entry: :group).where("debtor_id != creditor_id").where(groups: { id: group_id })
  end

  def credits
    user.credits.includes(entry: :group).where("debtor_id != creditor_id").where(groups: { id: group_id })
  end

  def balance
    (credits.sum(:amount_cents) - debts.sum(:amount_cents)) / 100.0
  end

  def liabilities
    hash = {}
    group.users.each do |user|
      hash[user] = liability_for(user)
    end
    hash.delete_if { |k, v| v.nil? }
  end

  private

  def liability_for(other_user)
    liability = (credits.where(debtor: other_user).sum(:amount_cents) - debts.where(creditor: other_user).sum(:amount_cents))
    liability >= 0 ? nil : liability.abs
  end
end
