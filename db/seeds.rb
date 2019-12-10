# frozen_string_literal: true

# this seeds demo data unless the tables have any values

create_sample_conditions = false

if Customer.all.empty?
	customers = Customer.create([{email: 'CustomerA@mailinator.com', company_name: 'Customer A'}, {email: 'CustomerB@mailinator.com', company_name: 'Customer B'}, {email: 'CustomerC@mailinator.com', company_name: 'Customer C'}, {email: 'CustomerD@mailinator.com', company_name: 'Customer D'}, {email: 'CustomerE@mailinator.com', company_name: 'Customer E'}])
	create_sample_conditions = true
end

# creates default flat fee adjustment which will apply to all customers unless they have another default set
if Adjustment.all.empty?
	Adjustment.create(discount: false, adjustment_value: 20 , percentage: false ,global_default: true, by_unit: true)
end


# create sample adjustment and conditions
if create_sample_conditions == true 
	(Customer.find_by company_name: 'Customer A').adjustments.create(discount: true, adjustment_value: 10, percentage: true, global_default: false)

	(Customer.find_by company_name: 'Customer B').adjustments.create(discount: false, adjustment_value: 1, percentage: false, global_default: false, by_volume: true)

	(Customer.find_by company_name: 'Customer C').adjustments.create(discount: false, adjustment_value: 5, percentage: true, global_default: false, by_value: true)

	adjustment1 = (Customer.find_by company_name: 'Customer D').adjustments.create(discount: true, adjustment_value: 5, percentage: true, global_default: false)
	adjustment1.conditions.create(min_units: 0, max_units: 100)
	adjustment2 =(Customer.find_by company_name: 'Customer D').adjustments.create(discount: true, adjustment_value: 10, percentage: true, global_default: false)
	adjustment2.conditions.create(min_units: 101, max_units: 200)
	adjustment3 =(Customer.find_by company_name: 'Customer D').adjustments.create(discount: true, adjustment_value: 15, percentage: true, global_default: false)
	adjustment2.conditions.create(min_units: 201, max_units: 300)
	adjustment4 =(Customer.find_by company_name: 'Customer D').adjustments.create(discount: false, adjustment_value: 2, percentage: false, global_default: false, by_volume: true)

	adjustment5 = (Customer.find_by company_name: 'Customer E').adjustments.create(discount: true, adjustment_value: 200, percentage: false, global_default: false)

	adjustment5.conditions.create(min_amount: 400)
end