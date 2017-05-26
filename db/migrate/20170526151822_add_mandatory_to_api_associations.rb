class AddMandatoryToApiAssociations < ActiveRecord::Migration[5.0]
  def change
    add_column :api_associations, :mandatory, :boolean, default: false

    ApiAssociation.all.each { |api_association| api_association.update_attribute(:mandatory, false) }
  end
end
