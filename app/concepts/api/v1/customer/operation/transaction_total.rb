# frozen_string_literal: true

module Api
  module V1
    module Customer
      module Operation
        class TransactionTotal < Trailblazer::Operation
          step :find_model!
          step :validate_item_json!
          step :apply_adjustments!
          def find_model!(options, params:, **)
            options['model'] = ::Customer.find(params[:customer_id])
          end

          def validate_item_json!(options, params:, **)
            params[:customer] = params[:customer].permit(items: [ :name, :length, :height, :width, :weight, :value])
          end

          def apply_adjustments!(options, params:, **)
            options['charges'] = []
            options['discounts'] = []

            # apply global charges  
            adjustment = Adjustment.where(:global_default => true, :customer_id => nil, :discount => false).first
            items = params[:customer][:items].as_json
            total_volume = 0
            items.each {|i| total_volume += (i['length'].to_f * i['height'].to_f * i['width'].to_f)}
            total_weight = 0
            items.each {|i| total_weight += i['weight'].to_f}
            total_value = 0
            items.each {|i| total_value += i['value'].to_f}
            if adjustment
              charge = {}
              charge['total'] = get_total_for_adjustment(adjustment, items, total_volume, total_weight, total_value)
              charge['adjustment'] = adjustment
              options['charges'] << charge
            end

            # apply customer specific charges
            options['model'].adjustments.find_all {|a|a.discount == false}.each do |a|
              # TODO check conditions

              charge = {}
              charge['total'] = get_total_for_adjustment(a, items, total_volume, total_weight, total_value)
              charge['adjustment'] = a
              options['charges'] << charge

            end


            # apply customer specific discounts

            options['model'].adjustments.where(:discount => true).each do |a|

              # TODO check conditions

              discount = {}
              discount['adjustment'] = a.as_json
              discount['adjustment']['conditions'] = a.conditions
              options['discounts'] << discount

            end
          


          end


          private

          def get_total_for_adjustment(adjustment, items, total_volume, total_weight, total_value)

              total = 0
              av = 0
              if adjustment.percentage == true 
                av = adjustment.adjustment_value / 100
              else
                av = adjustment.adjustment_value 
              end

              if adjustment.by_unit
                total = total + (items.count * av)
              end

              if adjustment.by_volume
                total = total + (total_volume * av)
              end

              if adjustment.by_weight
                total = total + (total_weight * av)
              end

              if adjustment.by_value
                total = total + (total_value * av)
              end

              total
          end

        end
      end
    end
  end
end

