class CreateErpFinancesServiceRegisters < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_finances_service_registers do |t|
      t.string :name
      t.decimal :price
      t.datetime :start_date
      t.datetime :end_date
      t.text :note
      t.references :user, index: true, references: :erp_users
      t.references :service, index: true, references: :erp_finances_services

      t.timestamps
    end
  end
end
