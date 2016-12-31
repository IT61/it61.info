class NullableSorceryCore < ActiveRecord::Migration
  def change
    change_column_null(:users, :email, true)
    change_column_null(:users, :crypted_password, true)
    change_column_null(:users, :salt, true)
  end
end
