class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.string :title_image
      t.string :place
      t.references :organizer, index: true
      t.boolean :published, default: false
      t.datetime :published_at
      t.boolean :subscribers_notification_send, default: false
      t.datetime :started_at
      t.timestamps
    end
  end
end
