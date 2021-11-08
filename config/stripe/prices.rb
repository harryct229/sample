# This file contains descriptions of all your stripe prices

# Example
# Stripe::Prices::LITE.lookup_key #=> 'lite'

# Prices will have a stripe generated id.  The lookup_key will match the
# configuration below.  You can fetch the ID or object from stripe:
#
#    Stripe::Prices::LITE.stripe_id #=> 'price_0000sdfs2qfsdf'
#    Stripe::Prices::LITE.stripe_object #=> #<Stripe::Price:0x3584 id=price_0000sdfs2qfsdf>...

# Prices are not deletable via the API, the `reset!` method will instead
# create a new price and transfer the lookup key to the new price.

# Stripe.price :enterprise_yearly do |price|
#   # Prices may belong to a product, this will create a product along with the price
#   price.name = 'Enterprise (Yearly)'

#   # You can also specify an existing product ID
#   price.product_id = Stripe::Products::PRO.id

#   # amount in cents. This is 6.99
#   price.unit_amount = 299000

#   # currency to use for the price (default 'usd')
#   price.currency = 'usd'

#   price.recurring = {
#     # interval must be either 'day', 'week', 'month' or 'year'
#     interval: 'year',
#   }
# end

# Stripe.price :enterprise_yearly do |price|
#   # Prices may belong to a product, this will create a product along with the price
#   price.name = 'Enterprise (Yearly)'

#   # You can also specify an existing product ID
#   # price.product_id = Stripe::Products::PRIMO.id

#   # amount in cents. This is 6.99
#   price.unit_amount = 299000

#   # currency to use for the price (default 'usd')
#   price.currency = 'usd'

#   price.recurring = {
#     # interval must be either 'day', 'week', 'month' or 'year'
#     interval: 'year',
#   }
# end

# Once you have your prices defined, you can run
#
#   rake stripe:prepare
#
# This will export any new prices to stripe.com so that you can
# begin using them in your API calls.
