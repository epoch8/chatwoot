class AddMetaToCustomAttributeDefinitions < ActiveRecord::Migration[6.1]
  def change
    add_column :custom_attribute_definitions, :meta, :jsonb
  end
end
