# Glysellin

Glysellin is a Rails lightweight e-commerce solution that helps you get simple products, orders and payment gateways without the whole set of functionalities a real e-commerce needs.

It is exposed as a mountable engine so you can customize what you want... doc be written

## Warning

Glysellin is under development and can now be used, but documentation is poor, there are no tests and API can change quickly while we don't have tested it within enough projects.


## Installing

To process to glysellin's installation, you shall use the install generator which will :

* Create an initializer file to configure the shop's behavior
* Copy all needed migrations
* Migrate and seed default data
* Mount the engine
* Copy the actions and mailers views to be overriden

The install generator command :

```bash
rails generate glysellin:install
```

## Using the Cart

The shopping cart contents are stored in user's cookies, with the key `glysellin.cart`

### Displaying the cart

Here is a simple code example that loads the cart for every controller action :

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :init

  def init
    @cart = Glysellin::Cart.new(cookies['glysellin.cart'])
  end
end
```

To display the cart you must render it's partial in your layout :

```erb
<%= render partial: "glysellin/cart/cart", locals: { cart: @cart } %>
```

### Filling the cart

To fill the cart, you can use the pre-built helper to create a simple "Add to cart" form that asynchronously updates user's cart contents.
You must pass the helper a `Glysellin::Product` instance in order to make it work :

```erb
<%= add_to_cart_form(@product) %>
```

## Gateway integration

The routes to redirect the payments gateways to are :

* For the automatic Server to Server response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/:gateway` where :gateway is the gateway slug
* For the "Return to shop" redirections :
    * Success response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/response/paid`
    * Error response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/response/cancel`
