# Glysellin

Glysellin is a Rails lightweight e-commerce solution that helps you get simple products, orders and payment gateways without the whole set of functionalities a real e-commerce needs.

In order to stay simple, we choosed for now to keep with some strong dependencies that may not fit to your app.

Also, no admin interface is provided so you can integrate it, but we always use [RailsAdmin](https://github.com/sferik/rails_admin).

## Dependencies

* [Devise](https://github.com/plataformatec/devise)
* [Paperclip](https://github.com/thoughtbot/paperclip)
* [Simple Form](https://github.com/plataformatec/simple_form)

## Disclaimer

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
<%= render_cart(@cart) %>
```

### Filling the cart

To fill the cart, you can use the pre-built helper to create a simple "Add to cart" form that asynchronously updates user's cart contents.
You must pass the helper a `Glysellin::Product` instance in order to make it work :

```erb
<%= add_to_cart_form(@product) %>
```

## Managing orders

By default, being bound to Devise, Glysellin automatically generates anonymous users to bind orders to. You can choose to keep this behavior alone, or add real subscription in the ordering process or remove the default behavior to force users to create an account by switching off the default functionality in the initializer (default parameter is commented) :

```ruby
# config/initializers/glysellin.rb
Glysellin.config do |config|
  # Allows creating fake accounts for customers with automatic random
  # password generation
  # Defaults to true
  #
  config.allow_anonymous_orders = true
end
```

## Customizing Order behavior

Since the Order object is implemented with the [state_machine gem](), it emits state transition events.
On install, a sample observer is copied to `app/models/order_observer.rb` in your application.
To be able to use it, you must configure your app to allow the `OrderObserver` to listen to `Order` state transitions by uncommenting and editing the following `active_record.observers` config line in your `application.rb` file :

```ruby
# config/application.rb

# Activate observers that should always be running.
config.active_record.observers = :order_observer
```


## Gateway integration

The routes to redirect the payments gateways to are :

* For the automatic Server to Server response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/:gateway` where :gateway is the gateway slug
* For the "Return to shop" redirections :
    * Success response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/response/paid`
    * Error response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/response/cancel`
