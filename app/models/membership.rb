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
    grouped_debts = debts.group(:creditor).sum(:amount_cents)
    grouped_credits = credits.group(:debtor).sum(:amount_cents)
    grouped_credits.merge(grouped_debts){ |user, credit, debit| debit - credit }.reject {|k, v|  v <= 0 }
  end
end
