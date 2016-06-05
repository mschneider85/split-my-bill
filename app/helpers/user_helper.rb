module UserHelper
  def online?(user)
    if user.last_seen && user.last_seen > 5.minutes.ago
      return true
    else
      return false
    end
  end
end
