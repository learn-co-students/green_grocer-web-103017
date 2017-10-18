def consolidate_cart(cart)
  count = Hash.new(0)
  cart.each do |hash|
    hash.each do |fruit, details|
      count[fruit] += 1
    end
  end
  result = {}
  cart.uniq.each do |hash|
    hash.each do |fruit, details|
      result[fruit] = {}
      details.each do |attribute, data|
        result[fruit][attribute] = data
      end
      result[fruit][:count] = count[fruit]
    end
  end
  result
end

def apply_coupons(cart, coupons)
  newcart = {}
  cart.each do |fruit, cart_details|
    coupons.each do |item_hash|
      item_hash.each do |detail, data|
        if detail == :item && data == fruit && cart_details[:count] >= item_hash[:num]
        cart_details[:count] = cart_details[:count] - item_hash[:num]
          if newcart[fruit + " W/COUPON"] == nil
            newcart[fruit + " W/COUPON"] = {:price => item_hash[:cost], :clearance => cart_details[:clearance], :count => (cart_details[:price] % item_hash[:num]).round}
          else
            newcart[fruit + " W/COUPON"][:count] += 1
          end
        end
      end
    end
  end
  cart.each do |fruit, cart_details|
    newcart[fruit] = cart_details
  end
  newcart
end

def apply_clearance(cart)
  cart.each do |item, details|
    if details[:clearance] == true
      details[:price] = (details[:price] * 0.8).round(1)
    end
  end
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  total = 0
  cart.each do |item, details|
    total += (details[:price])*(details[:count])
  end

  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end
