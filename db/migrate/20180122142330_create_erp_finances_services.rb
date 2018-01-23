class CreateErpFinancesServices < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_finances_services do |t|
      t.string :image_url
      t.string :brochures
      t.string :link_docs
      t.string :name
      t.text :description
      t.text :content
      t.string :meta_keywords
      t.string :meta_description
      t.string :service_icon
      t.boolean :is_home, default: false
      t.string :is_main, default: false
      
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
