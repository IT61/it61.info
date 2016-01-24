class CreateCompanyMembershipRequests < ActiveRecord::Migration
  def change
    create_table :company_membership_requests do |t|
      t.references :company, index: true, null: false
      t.references :user, index: true, null: false
      t.boolean :approved, default: false
      t.boolean :hidden, default: false
      t.timestamps
    end
    add_index :company_membership_requests, [:approved, :hidden]
  end
end
