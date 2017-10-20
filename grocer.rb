require 'pry'

def consolidate_cart(cart)
  new_cart = {}
  keys = []
  count = 0

  cart.each do |hash|
    hash.each do |key, value|#key: "TEMPEH" value:{:price=>3.0, :clearance=>true}
      keys.include?(key) ? count += 1 : count = 1
      keys << key
      new_cart[key] = value
      new_cart[key][:count] = count
    end
  end
  new_cart
#   {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 2},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
# }
end


def apply_coupons(cart, coupons)
  coupon_list = []
  count = 0
  used_values = []

  coupons.each do |coupon|#{:item => "AVOCADO", :num => 2, :cost => 5.0}
    coupon.each do |category, value|#:item, "AVOCADO"

      if cart.keys.include?(value)
        if cart[value][:count] >= coupon[:num]
          if used_values.include?(value)
            count += 1
          else
            count = 1
            used_values << value
          end

          cart["#{value} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => cart[value][:clearance],
            :count => count
          }
          cart[value][:count] -= coupon[:num]
        end
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item, info|#'TEMPEH', hash

    if info[:clearance] == true
      info[:price] *= 0.8
      info[:price] = info[:price].round(3)

    end
  end
  cart
end


def checkout(cart, coupons)#[{"BEETS"=>{:price=>2.5, :clearance=>false, :count=>1}}], []
  total = 0
  #
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)

  final_cart.each do |item, info|#{"BEETS"=>{:price=>2.5, :clearance=>false, :count=>1}}
    total += (info[:price] * info[:count])
  end

  if total > 100
    total *= 0.9
  end
  total
end
