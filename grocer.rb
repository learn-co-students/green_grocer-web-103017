def consolidate_cart(cart)
  # code here
  consol_cart = Hash.new
  food_arr = []
  cart.each do |item_hash|
    item_hash.each do |food, info|
      food_arr << food
      consol_cart[food] = info
      info[:count] = 0
    end
  end
  food_arr.each do |food|
    consol_cart[food][:count]  = consol_cart[food][:count] + 1
  end
  consol_cart
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |hash|
    hash.each do |category, value|
      if cart.keys.include?(hash[:item])
        if category == :item
          cart[value + " W/COUPON"] = {price: hash[:cost], clearance: cart[value][:clearance], count: cart[value][:count] / hash[:num]}
          cart[value][:count] = cart[value][:count] % hash[:num]
        end
      end
    end
  end

  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item, value|
    if value[:clearance] == true
      value[:price] = (value[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  consolidate_cart(cart).each do |item, info|
    item "="
  end
end
