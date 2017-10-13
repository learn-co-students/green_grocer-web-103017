require 'pry'

def consolidate_cart(cart)
  consolidated_hash = Hash.new(0)
  cart.each do |array_el|
    array_el.each do |item, info_hash|
      if consolidated_hash[item] == 0
        consolidated_hash[item] = info_hash
        consolidated_hash[item][:count] = 0
      end
      consolidated_hash[item][:count] += 1
    end
  end
  consolidated_hash
end

def apply_coupons(cart, coupons)
  return_hash = Hash.new(0)
  coupons.each do |coupon_hash|
    cart.each do |item, info_hash|
      if coupon_hash[:item] == item && coupon_hash[:num] <= info_hash[:count]
        coupon_applied = "#{item} W/COUPON"
        if return_hash.keys.include?(coupon_applied)
          return_hash[coupon_applied][:count] += 1
          info_hash[:count] -= coupon_hash[:num]
        else
          return_hash[coupon_applied]= Hash.new(0)
          return_hash[coupon_applied][:price]= coupon_hash[:cost]
          return_hash[coupon_applied][:clearance]= info_hash[:clearance]
          return_hash[coupon_applied][:count] += 1
          info_hash[:count] -= coupon_hash[:num]
        end
      end
    end
  end
  cart.merge(return_hash)
end


def apply_clearance(cart)
  cart.collect do |item, info_hash|
    if info_hash[:clearance] == true
      info_hash[:price]= (info_hash[:price]*0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  final_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  final_cart.each do |item, info_hash|
    total += (info_hash[:count]*info_hash[:price]).round(2)
  end
  if total > 100
    (total*0.9).round(2)
  else
    total
  end
end
