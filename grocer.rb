
cart = {
  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
}


 coupons = [ {:item => "AVOCADO", :num => 2, :cost => 5.00},
   {:item => "BEER", :num => 2, :cost => 20.00},
   {:item => "CHEESE", :num => 3, :cost => 15.00}
 ]


def consolidate_cart(cart)
  organized_cart = {}
  cart.each do |item_hash|
    item_hash.each do |item, details_hash|
      if organized_cart.key?(item)
        organized_cart[item][:count] += 1
      else
        organized_cart[item] = details_hash
        organized_cart[item][:count] = 1
      end
    end
  end
  organized_cart
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    if cart.key?(coupon_hash[:item])
      cart["#{coupon_hash[:item]} W/COUPON"] ||= {}
      cart["#{coupon_hash[:item]} W/COUPON"][:price] = coupon_hash[:cost]
      cart["#{coupon_hash[:item]} W/COUPON"][:clearance] = cart[coupon_hash[:item]][:clearance]
      cart["#{coupon_hash[:item]} W/COUPON"][:count] ||= 0
      #make sure there at least as many of the item in the cart
      #as the coupon applies for
      if cart[coupon_hash[:item]][:count] >= coupon_hash[:num]
        cart["#{coupon_hash[:item]} W/COUPON"][:count] += 1
        cart[coupon_hash[:item]][:count] -= coupon_hash[:num]
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item, details_hash|
    if details_hash[:clearance] == true
      details_hash[:price] = (details_hash[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  subtotal =  0
  cart.each do |item, details_hash|
    subtotal += details_hash[:price] * details_hash[:count]
  end
  return subtotal if subtotal <= 100
  return (subtotal * 0.9).round(2)
end
