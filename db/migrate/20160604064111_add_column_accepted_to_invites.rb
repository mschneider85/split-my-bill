class AddColumnAcceptedToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :accepted, :boolean, null: false, default: false
  end
end
