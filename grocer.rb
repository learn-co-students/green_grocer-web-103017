require "pry"

def consolidate_cart(cart)
  output = {}
  newcart = []
  cart.each do |item|
    if item.is_a?(Array)
      newcart << [item[0], item[1]]
    else
      item.each do |key, value|
        newcart << [key, value]
      end
    end
  end
  newcart.each do |type|
    charkey = type[0]
    charhash = type[1]
    if output.include?(charkey) == false
      output[charkey] = charhash
      charhash[:count] = 1
    else
      output[charkey][:count] += 1
    end
  end
  return output
end

def apply_coupons(cart, coupons)
  newcart = {} #forget this, just modify the original cart
  coupons.each do |coupon|
    if coupons.length == 0
      return cart
    else
      cart.each do |item|
        #binding.pry
        item_name = item[0]
        atts = item[1]
        if item_name == coupon[:item]
          if atts[:count] >= coupon[:num]
            newcart[item_name + " W/COUPON"] = {
              price: coupon[:cost],
              clearance: atts[:clearance],
              count: atts[:count] / coupon[:num]
            }
            newcart[item_name] = atts
            newcart[item_name][:count] = atts[:count] % coupon[:num]
          else
            newcart[item_name] = atts
          end
        elsif newcart.include?(item_name) == false
          newcart[item_name] = atts
        end
      end
    end
  end
  return newcart if newcart.length > 0 else return cart
end

def apply_clearance(cart)
  cart.each do |item|

    if item[1][:clearance] == true
      item[1][:price] = item[1][:price] * 0.8
      item[1][:price] = item[1][:price].round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  newcart = []
  cart.each do |item|
    item.each do |key, value|
      newcart << [key, value]
    end
  end
  newcart = consolidate_cart(cart)
  newcart = apply_coupons(newcart, coupons)
  newcart = apply_clearance(newcart)
  total = 0
  newcart.each do |item|
    total += item[1][:price] * item[1][:count]
  end
  if total > 100
    total = total * 0.9
    total = total.round(2)
  end
  return total
end

=begin
testcart = [{"BEETS"=>{:price=>2.5, :clearance=>false, :count=>1}},
 {"BEER"=>{:price=>13.0, :clearance=>false, :count=>1}},
 {"BEER"=>{:price=>13.0, :clearance=>false, :count=>1}},
 {"BEER"=>{:price=>13.0, :clearance=>false, :count=>1}}]

testcoupon = [{:item => "BEER", :num => 2, :cost => 20.00}]

testcart = consolidate_cart(testcart)
puts testcart
testcart = apply_coupons(testcart, testcoupon)
puts testcart
=end
