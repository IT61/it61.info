class AddVisitedFlagToParticipations < ActiveRecord::Migration[5.0]
  def change
    add_column :event_participations, :visited, :boolean, default: false
  end
end
