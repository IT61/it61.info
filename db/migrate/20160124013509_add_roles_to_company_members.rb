class AddRolesToCompanyMembers < ActiveRecord::Migration
  def change
    add_column :company_members, :roles, :integer, index: true, default: 0
  end
end
