class CreateErpFinancesServices < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_finances_services do |t|
      t.string :image_url
      t.string :name
      t.string :alias
      t.text :description
      t.text :content
      t.string :icon
      t.string :brochures
      t.string :link_docs      
      t.string :meta_keywords
      t.string :meta_description
      t.integer :custom_order
      t.boolean :is_home, default: false
      t.boolean :is_main, default: false
      
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
