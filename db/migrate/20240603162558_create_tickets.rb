class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :email
      t.datetime :booking_date
      t.string :bus_name
      t.integer :quantity
      t.string :start_location
      t.string :end_location

      t.timestamps null: false
    end
  end
end
