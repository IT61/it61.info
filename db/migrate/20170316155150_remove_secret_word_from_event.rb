class RemoveSecretWordFromEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :secret_word
  end
end
