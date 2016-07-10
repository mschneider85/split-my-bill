class GroupReport
  include ActiveModel::Model
  include ActionView::Helpers::NumberHelper

  def initialize(group)
    @group = group
  end

  def persisted?
    false
  end

  def expenses_sum
    number_to_currency expenses.sum('amount_cents/100.0')
  end

  def expenses_avg
    number_to_currency expenses.sum('amount_cents/100.0')/users.count
  end

  def first_expense
    I18n.l(expenses.order(created_at: :asc).first.created_at, format: :short_date)
  end

  def last_expense
    I18n.l(expenses.order(created_at: :desc).first.created_at, format: :short_date)
  end

  private

  def expenses
    @group.entries.where(entry_type: 'expense')
  end

  def users
    @group.users
  end
end
