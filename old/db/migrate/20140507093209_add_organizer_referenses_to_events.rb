class AddOrganizerReferensesToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :organizer, index: true
  end
end
