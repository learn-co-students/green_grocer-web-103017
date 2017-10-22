require 'pry'
def consolidate_cart(cart)
  # code here
  #[{"AVOCADO"=>{:price=>3.0, :clearance=>true}}, {"KALE"=>{:price=>3.0, :clearance=>false}}]
  cart_items = []
  cart.each do |key|
    key.each do |nkey, val|
      cart_items.push(nkey)
    end
  end

  new_cart = {}

  cart.uniq.each do |key|
    key.each do |nkey, val|
      new_cart[nkey] = val
      new_cart[nkey][:count] = cart_items.count(nkey)
    end
  end

  new_cart

end

def apply_coupons(cart, coupons)
  # code here
  count = 0
  coupons.each do |key, value|
    if cart.key?(coupons[count][:item]) == true
      if cart[coupons[count][:item]][:count] >= coupons[count][:num]
        cart["#{coupons[count][:item]} W/COUPON"] = {:price => coupons[count][:cost], :clearance => cart[coupons[count][:item]][:clearance], :count => cart[coupons[count][:item]][:count] / coupons[count][:num]}
        cart[coupons[count][:item]][:count] = cart[coupons[count][:item]][:count] - (coupons[count][:num] * (cart[coupons[count][:item]][:count] / coupons[count][:num]))
      end
    end
    count += 1
  end
  cart

end



def apply_clearance(cart)
  # code here
  cart.each do |key, value|
    if value[:clearance] == true
      value[:price] = (value[:price] * 0.8).round(1)
    end
  end

end

def checkout(cart, coupons)
  # code here
  total =  0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |key, val|
    total += val[:price] * val[:count]
  end
  if total <= 100
    return total
  else
    return (total * 0.9).round(2)
  end
end
