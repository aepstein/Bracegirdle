class AddPhysicalCharacteristicsToCemeteryInspections < ActiveRecord::Migration[5.2]
  def change
    add_column :cemetery_inspections, :sign_comments, :string
    add_column :cemetery_inspections, :offices, :boolean
    add_column :cemetery_inspections, :offices_comments, :string
    add_column :cemetery_inspections, :rules_displayed, :boolean
    add_column :cemetery_inspections, :rules_displayed_comments, :string
    add_column :cemetery_inspections, :prices_displayed, :boolean
    add_column :cemetery_inspections, :prices_displayed_comments, :string
    add_column :cemetery_inspections, :scattering_gardens, :boolean
    add_column :cemetery_inspections, :scattering_gardens_comments, :string
    add_column :cemetery_inspections, :community_mausoleum, :boolean
    add_column :cemetery_inspections, :community_mausoleum_comments, :string
    add_column :cemetery_inspections, :proposed_mausoleum, :boolean
    add_column :cemetery_inspections, :proposed_mausoleum_comments, :string
    add_column :cemetery_inspections, :private_mausoleum, :boolean
    add_column :cemetery_inspections, :private_mausoleum_comments, :string
    add_column :cemetery_inspections, :lawn_crypts, :boolean
    add_column :cemetery_inspections, :lawn_crypts_comments, :string
    add_column :cemetery_inspections, :grave_liners, :boolean
    add_column :cemetery_inspections, :grave_liners_comments, :string
    add_column :cemetery_inspections, :sale_of_monuments, :boolean
    add_column :cemetery_inspections, :sale_of_monuments_comments, :string
    add_column :cemetery_inspections, :fencing, :boolean
    add_column :cemetery_inspections, :fencing_comments, :string
    add_column :cemetery_inspections, :main_road, :text
    add_column :cemetery_inspections, :side_roads, :text
    add_column :cemetery_inspections, :new_memorials, :text
    add_column :cemetery_inspections, :old_memorials, :text
    add_column :cemetery_inspections, :vandalism, :text
    add_column :cemetery_inspections, :hazardous_materials, :text
    add_column :cemetery_inspections, :receiving_vault_exists, :boolean
    add_column :cemetery_inspections, :receiving_vault_inspected, :boolean
    add_column :cemetery_inspections, :receiving_vault_bodies, :string
    add_column :cemetery_inspections, :receiving_vault_clean, :boolean
    add_column :cemetery_inspections, :receiving_vault_obscured, :boolean
    add_column :cemetery_inspections, :receiving_vault_exclusive, :boolean
    add_column :cemetery_inspections, :receiving_vault_secured, :boolean
  end
end
