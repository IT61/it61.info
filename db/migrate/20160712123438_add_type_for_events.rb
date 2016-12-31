class AddTypeForEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :registration_type, :integer
    add_column :events, :participants_limit, :integer
  end
end
