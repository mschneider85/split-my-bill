class CreateGroup
  def self.call(group, current_user)
    if group.save
      group.users << current_user
      group.create_activity key: 'group.create', owner: current_user
    end
    group
  end
end
