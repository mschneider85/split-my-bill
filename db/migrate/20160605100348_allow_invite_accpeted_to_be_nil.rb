class AllowInviteAccpetedToBeNil < ActiveRecord::Migration
  def change
    change_column_null(:invites, :accepted, true)
    change_column_default(:invites, :accepted, nil)
  end
end
