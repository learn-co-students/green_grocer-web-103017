require "pry"
def consolidate_cart(cart)
  new_cart = {}
  cart.each do |hashes|
    hashes.each do |item, details|
      if new_cart.has_key?(item)
        new_cart[item][:count] += 1
      else
      new_cart[item] = details
      new_cart[item][:count] = 1
    end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  #binding.pry
  if coupons == []
    return cart
  end
  coupons.each_with_index do |coup, index|

  if cart.has_key?(coup[:item]) && cart[coup[:item]][:count] >= coup[:num]
    if cart.has_key?("#{coup[:item]} W/COUPON")
      cart["#{coup[:item]} W/COUPON"][:count] += 1
      cart[coup[:item]][:count] = cart[coup[:item]][:count] - coup[:num]
    else
    cart["#{coup[:item]} W/COUPON"] = {:price => coup[:cost], :clearance => cart[coup[:item]][:clearance], :count => 1}
    cart[coup[:item]][:count] = cart[coup[:item]][:count] - coup[:num]
  end
  end
end
  cart
end

def apply_clearance(cart)
  cart.each do |item, details|
    if details[:clearance]
      twomp = details[:price] / 5
      details[:price] -= twomp
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  #calculate total
  total = 0
  cart.each do |item, details|
    total += (details[:price] * details[:count])
  end
  if total > 100
    total *= 0.9
  end
  total
end
