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

    total = debts_sum.to_h.merge(credits_sum.to_h){ |key, oldval, newval| newval > 0 ? (newval - oldval) : - oldval}

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
          allowDecimals: false,
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

  def entries
    Entry.includes(:transactions).where(group: @user.groups).where.any_of({transactions: { creditor: @user }}, {transactions: { debtor: @user }})
  end

  private

  def first_transaction_date
    transactions = Transaction.where.any_of(creditor: @user, debtor: @user).order(:created_at).limit(1).pluck(:created_at)
    transaction = transactions.present? ? transactions.first.to_date : @user.created_at.to_date
  end

  def credits_by_day
    Rails.cache.fetch("#{cache_key}/credits_by_day") do
      hash = {}
      (first_transaction_date..Date.current).each do |date|
        hash[date] = @user.credits.where.not(debtor: @user).where(created_at: date.beginning_of_day..date.end_of_day).sum("amount_cents/100.0")
      end
      hash
    end
  end

  def debts_by_day
    Rails.cache.fetch("#{cache_key}/debts_by_day") do
      hash = {}
      (first_transaction_date..Date.current).each do |date|
        hash[date] = @user.debts.where.not(creditor: @user).where(created_at: date.beginning_of_day..date.end_of_day).sum("amount_cents/100.0")
      end
      hash
    end
  end

  def cache_key
    @cache_key ||= "#{@user.id}#{@user.debts&.last&.created_at.to_i}#{@user.credits&.last&.created_at.to_i}#{@user.updated_at.to_i}"
  end
end
