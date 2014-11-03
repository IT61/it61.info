namespace :it61 do

  desc "Удалить из БД записи, которые помечены, как удаленные"
  task really_destroy_entities: :environment do
    %w(user event).each do |model_name|
      deleted_entities = model_name.classify.constantize.only_deleted
      p "Model: #{model_name.classify}, #{deleted_entities.count} deleted entities found."
      next if deleted_entities.blank?

      deleted_entities.each do |o|
        o.really_destroy!
        p "Model: #{model_name.classify} (id: #{o.id}) really destroyed."
      end
    end
  end
end
