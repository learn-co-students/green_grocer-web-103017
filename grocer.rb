def consolidate_cart(cart)
  new_cart = {}
  cart.each do |x|
    x.each do |item, hash|
      hash.each do |cate, val|
        if new_cart[item] == nil
          new_cart[item] = {}
        end
        new_cart[item][cate] = val
      end
      if new_cart[item][:count] == nil
        new_cart[item][:count] = 0
      end
      new_cart[item][:count] += 1
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
	if coupons == []
		return cart
	else
		coupons.each do |coupon_hash|
  		if cart.keys.include?(coupon_hash[:item])
        new_item = coupon_hash[:item] + " W/COUPON"
  			unless cart.keys.include?(new_item)
  			  cart[new_item] = {}
          cart[new_item][:price] = coupon_hash[:cost]
          cart[new_item][:clearance] = cart[coupon_hash[:item]][:clearance]
          cart[new_item][:count] = 0
        end
        # The following if statement makes the coupon only apply if the :num is greater than the count in the cart. Otherwise, No discount!
        if cart[coupon_hash[:item]][:count] >= coupon_hash[:num]
          cart[coupon_hash[:item]][:count] -= coupon_hash[:num]
          cart[new_item][:count] += 1
        end
  		end
 	 	end
 	end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info_hash|
    if info_hash[:clearance] == true
      info_hash[:price] -= (info_hash[:price] * 0.2)
    end
  end
end

def checkout(cart, coupons)
  total = 0.0
  apply_clearance(apply_coupons(consolidate_cart(cart), coupons)).each do |item, info_hash|
    total += info_hash[:price] * info_hash[:count]
  end
  if total > 100.00
    total -= total * 0.1
  end
  total
end
