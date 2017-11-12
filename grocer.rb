def consolidate_cart(cart)
  # code here
  cart_uniq = cart.uniq
  output = Hash.new{|output,key| output[key] =0}
  cart_uniq.each do |item|
    item.each do |key,value|
      output[key]=value
      output[key][:count] = 0
    end
  end
  cart.each do |item|
    item.each do |key,value|
#      output[key]=value
      output[key][:count] += 1 if output.has_key?(key)
    end
  end
  output
end

def apply_coupons(cart, coupons)
  # code here
  output = {}
  cart.each do |key,value|
    coupons.each do |coupon|
      if (coupon[:item] == key && value[:count] >= coupon[:num])
        new_key = key + " W/COUPON"
        if output.has_key?(new_key)
          output[new_key][:count] += 1
          # output[key][:count] = output[key][:count] - coupon[:num]
          value[:count]= value[:count] - coupon[:num]
        else
          output[new_key] = {}
          output[new_key][:price] = coupon[:cost]
          output[new_key][:clearance] = value[:clearance]
          output[new_key][:count] = 1
          # output[key][:count] = output[key][:count] - coupon[:num]
          value[:count] = value[:count] - coupon[:num]
        end
      end
    end
  end
  cart.merge(output)
end

def apply_clearance(cart)
  # code here
  cart.collect{|key,value| value[:price] = (value[:price]*0.8).round(2) if value[:clearance] == true}
  cart
end

def checkout(cart, coupons)
  # code here
  new_cart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  sum = 0
  new_cart.each{|key,value| sum += value[:count]*value[:price]}
  sum > 100 ? sum*0.9.round(2) : sum.round(2)
end
