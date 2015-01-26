class ChangeSubscribedInUsers < ActiveRecord::Migration
  def up
    change_column_default :users, :subscribed, nil
  end

  def down
    change_column_default :users, :subscribed, true
  end
end
