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
    expenses.any? ? I18n.l(expenses.order(created_at: :asc).first.created_at, format: :short_date) : '-'
  end

  def last_expense
    expenses.any? ? I18n.l(expenses.order(created_at: :desc).first.created_at, format: :short_date) : '-'
  end

  def successive_expenses_sum
    s = 0
    expenses.group_by_day(:created_at, series: false).sum("amount_cents/100.0").map{ |k,v| [k, (s = s + v).to_f] }
  end

  def chart_options
    {
      library: {
        yAxis: {
          allowDecimals: false,
          labels: {
            format: '{value} EUR' } },
        xAxis: {
          type: 'datetime',
          labels: {
            format: '{value: %d.%b}' } },
        tooltip: {
          headerFormat: 'Gesamtkosten<br>{point.x: %d.%m.%Y}<br>',
          pointFormat: '<b>{point.y:,.2f} EUR</b>' } },
      min: expenses_sum_on_creation_date,
      colors: ["#3c8dbc"],
      height: "220px"
    }
  end

  private

  def expenses
    @group.entries.where(entry_type: 'expense')
  end

  def expenses_sum_on_creation_date
    expenses.where('DATE(created_at) = ?', @group.created_at.to_date).sum('amount_cents/100.0').to_f
  end

  def users
    @group.users
  end
end
