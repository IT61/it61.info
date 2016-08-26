class AddSecretWordForEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :secret_word, :string
  end
end
