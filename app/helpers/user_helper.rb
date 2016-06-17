module UserHelper
  def online?(user)
    if user.last_seen && user.last_seen > 5.minutes.ago
      return true
    else
      return false
    end
  end

  def bootstrap_state_for_balance(amount)
    if amount > 0
      "success"
    elsif amount < 0
      "danger"
    else
      "primary"
    end
  end
end
