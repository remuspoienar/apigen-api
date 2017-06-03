class ChangeApiAssociationsAdvancedOptions < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      change_table :api_associations do |t|
        dir.up do
          ApiAssociation.where(advanced_options: '').find_each { |api_association| api_association.update_attribute(:advanced_options, '{}') }
          t.change :advanced_options, :json, using: 'advanced_options::json'
        end

        dir.down do
          t.change :advanced_options, :text
        end
      end
    end
  end
end
