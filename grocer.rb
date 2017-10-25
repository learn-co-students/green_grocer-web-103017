# [ {"AVOCADO" => {:price => 3.0, :clearance => true }}, {"AVOCADO" => {:price => 3.0, :clearance => true }}, {"KALE"    => {:price => 3.0, :clearance => false}}]

def consolidate_cart(cart)
  result = Hash.new(0)
  cart.each do |item|
    name, data = item.first
    if result.has_key?(name)
      result[name][:count] += 1
    else
      result[name] = data
      result[name][:count] = 1
    end
  end
  result
end
# {
#   "AVOCADO" => {
#     :price => 3.0,
#     :clearance => true,
#     :count => 3
#   },
#   "KALE"    => {
#     :price => 3.0,
#     :clearance => false,
#     :count => 1
#   }
# }
#  # {:item => "AVOCADO", :num => 2, :cost => 5.0}

# {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 1},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1},
#   "AVOCADO W/COUPON" => {:price => 5.0, :clearance => true, :count => 1},


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_for = coupon[:item]
    if cart.has_key?(coupon_for) && cart[coupon_for][:count] >= coupon[:num]
      cart[coupon_for][:count] -= coupon[:num]
      new_name = "#{coupon_for} W/COUPON"
      if cart.has_key?(new_name)
        count = cart[new_name][:count] + 1
      else
        count = 1
      end
      cart[new_name] = {
        :price => coupon[:cost],
        :clearance => cart[coupon_for][:clearance],
        :count => count
      }
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_data|
    if item_data[:clearance] == true
      item_data[:price] = (item_data[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cost = 0
  cart.each do |item, item_data|
    cost += item_data[:price] * item_data[:count]
  end
  if cost > 100
    cost *= 0.9
  end
  cost.round(2)
end
