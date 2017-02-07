class CreatePostreleases < ActiveRecord::Migration[5.0]
  def change
    create_table :postreleases do |t|
      t.text :body
    end
  end
end
