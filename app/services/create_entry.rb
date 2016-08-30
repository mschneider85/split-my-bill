class CreateEntry
  def self.call(current_user, user_ids, entry)
    users = User.where(id: user_ids.reject(&:blank?))

    splitted_amount = 0.0

    users.without(current_user).each do |user|
      current_amount = ((100.0*entry.amount.to_d/users.count).to_f.ceil)/100.0
      entry.transactions.build(amount: current_amount, creditor: current_user, debtor: user)
      splitted_amount += current_amount
    end

    if users.find_by(id: current_user)
      entry.transactions.build(amount: (entry.amount.to_f)-splitted_amount, creditor: current_user, debtor: current_user)
    end

    if entry.save
      case entry.entry_type
      when 'redemption'
        entry.create_activity key: 'entry.create_redemption', owner: current_user
      else
        entry.create_activity key: 'entry.create', owner: current_user
      end
    end
    entry
  end
end
