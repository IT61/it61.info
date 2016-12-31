RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

class AttributesForWithForeignKeys
  def association(runner)
    runner.run(:create)
  end

  def result(evaluation)
    attribute_assigner = evaluation.instance_variable_get(:@attribute_assigner)
    attribute_names = attribute_assigner.send(:attribute_names_to_assign)

    attribute_names.each do |attr|
      attribute_names += FactoryGirl.aliases_for(attr)
    end

    evaluation.object.attributes.symbolize_keys.slice(*attribute_names)
  end
end

FactoryGirl.register_strategy(:attributes_for_with_foreign_keys, AttributesForWithForeignKeys)
