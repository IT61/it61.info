class CreateCompanyMembers < ActiveRecord::Migration
  def change
    create_table :company_members do |t|
      t.references :company, index: true
      t.references :user, index: true
      t.string :position
      t.timestamps
    end
  end
end
