class AddBaseTables < ActiveRecord::Migration[6.0]
  def change
  	create_table :customers do |t|
  		t.string :email
  		t.string :company_name
  		t.timestamps
  	end

  	create_table :adjustments do |t|
  		t.integer :customer_id
  		t.boolean :discount 
  		t.boolean :percentage
  		t.float :adjustment_value
  		t.boolean :global_default, default: false
  		t.boolean :by_unit, default: false
  		t.boolean :by_volume, default: false
  		t.boolean :by_weight, default: false
  		t.boolean :by_value, default: false
  		t.timestamps
  	end

  	create_table :conditions do |t|
  		t.references :adjustment, foreign_key: true
  		t.datetime :start_date
  		t.datetime :end_date
  		t.integer :min_units
  		t.integer :max_units
  		t.float :min_amount
  		t.float :max_amount
  		t.integer :remaining_count
  	end
  end
end
