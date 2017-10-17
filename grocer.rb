require "pry"

def consolidate_cart(cart)
  consolidated = {}
  cart.each do |item| # item in array at index x
    #binding.pry
    item.each do |item_name, item_hash| # item_name => {item_hash}
      #binding.pry
      if consolidated[item_name].nil? # does item_name exist in the consolidated cart?
        consolidated[item_name] = {
          :price => item_hash[:price],
          :clearance => item_hash[:clearance],
          :count => 1
        }
      else # if item_name exists, add to count
        consolidated[item_name][:count] += 1
      end
      #binding.pry
    end
  end
  return consolidated
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |coupon|
    #binding.pry
    coupon_entry = "#{coupon[:item]} W/COUPON"
    if cart["#{coupon[:item]} W/COUPON"].nil? # Does the coupon exist in the cart already?
      #binding.pry
      if cart.include?(coupon[:item]) # Does the coupon's target item exist in the cart?
        #binding.pry
        if coupon[:num] <= cart[coupon[:item]][:count] # Are there enough (count) of the item to apply the coupon?
            cart[coupon[:item]][:count] -= coupon[:num]
            cart[coupon_entry] = {
              :price => coupon[:cost],
              :clearance => cart[coupon[:item]][:clearance],
              :count => 1
          }
        end
        # once coupon is applied, check if item count is now 0, if so, delete
        if cart[coupon[:item]][:count] == 0
          cart.delete(cart[coupon[:item]])
        end
        #binding.pry
      end
    else  # If the coupon already exists in the cart
      if cart[coupon[:item]][:count] >= coupon[:num]
        cart[coupon[:item]][:count] -= coupon[:num]
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
      end
      # once coupon is applied, check if item count is now 0, if so, delete
      if cart[coupon[:item]][:count] == 0
        cart.delete(cart[coupon[:item]])
      end
    end

  end
  #binding.pry
  return cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item, attributes|
    #binding.pry
    if attributes.fetch(:clearance)
      attributes[:price] *= 0.8
      attributes[:price] = attributes[:price].round(2)
      #binding.pry
    end
  end
  return cart
end

def checkout(cart, coupons)
  # code here
  cost = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  #binding.pry
  cart = apply_clearance(cart)
  cart.each do |items, item_hash|
    #binding.pry
    cost += (item_hash[:price] * item_hash[:count])
  end
  if cost > 100
    #binding.pry
    cost *= 0.9
    cost.round(2)
    return cost
  end
  #binding.pry
  return cost
end
