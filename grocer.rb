def consolidate_cart(cart)
  new_cart={}
    cart.each do |item|
      if new_cart.include?(item.keys.first)
         new_cart[item.keys.first][:count] += 1
      else
         new_cart[item.keys.first] = item.values.first.merge({:count => 1})
      end
    end
  new_cart
end


def apply_coupons(cart, coupons)
  cart.keys.each do |item|
    coupons.each do |coupon|
      if item == coupon[:item] && cart[item][:count] >= coupon[:num]
        cart[item][:count] -= coupon[:num]
        if cart["#{coupon[:item]} W/COUPON"]
          cart["#{coupon[:item]} W/COUPON"][:count] += 1
        else
          cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item][:clearance], :count => 1}
        end
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |food, hash|
     if hash[:clearance] == true
       hash[:price] = (hash[:price]*0.8).round(2)
     end
  end
end


def checkout(cart, coupons)
    cart = consolidate_cart(cart)
    cart = apply_coupons(cart, coupons)
    cart = apply_clearance(cart)
    total = 0
     cart.each do |item, properties|
       total += properties[:price] * properties[:count]
     end

     if total > 100
      total -= total * 0.1
    end

     total
end
