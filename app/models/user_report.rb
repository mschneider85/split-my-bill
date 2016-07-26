class UserReport
  include ActiveModel::Model
  include ActionView::Helpers::NumberHelper

  def initialize(user)
    @user = user
  end

  def persisted?
    false
  end

  def chart_data
    c, d = [0, 0]
    credits_sum = credits_by_day.map{ |k, v| [k, (c = c + v)] }
    debts_sum = debts_by_day.map{ |k, v| [k, (d = d + v)] }

    total = debts_sum.to_h.merge(credits_sum.to_h){|key, oldval, newval| newval - oldval}

    @data = [
      { name: 'Kontostand', data: total },
      { name: 'Kredite', data: credits_by_day },
      { name: 'Schulden', data: debts_by_day }
    ]
  end

  def chart_options
    {
      library: {
        yAxis: {
          labels: {
            format: '{value} EUR' } },
        xAxis: {
          type: 'datetime',
          labels: {
            format: '{value: %d.%b}' } },
        tooltip: {
          headerFormat: '{point.x: %d.%m.%Y}<br>',
          shared: true,
          pointFormat: '<span style="color: {point.series.color}">⚫ </span>{point.series.name}: <b>{point.y:,.2f} EUR</b><br>' },
        colors: ['#3c8dbc', '#00a65a', '#dd4b39'] }
    }
  end

  def total_balance
    @user.memberships.map(&:balance).sum
  end

  def balance_change_on_date(date)
    credits_sum = @user.credits.where("debtor_id != creditor_id").where(created_at: date.beginning_of_day..date.end_of_day).sum(:amount_cents)
    debts_sum = @user.debts.where("debtor_id != creditor_id").where(created_at: date.beginning_of_day..date.end_of_day).sum(:amount_cents)
    (credits_sum - debts_sum) / 100.0
  end

  private

  def credits_by_day
    @user.credits.where.not(debtor: @user).group_by_day(:created_at).sum("amount_cents/100.0")
  end

  def debts_by_day
    @user.debts.where.not(creditor: @user).group_by_day(:created_at).sum("amount_cents/100.0")
  end
end
