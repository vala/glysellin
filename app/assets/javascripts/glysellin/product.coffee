class GlysellinProduct
  constructor: (@container, @cart_container) ->
    @add_to_cart_form = @container.find('.add-to-cart-form')
    @bindAll()

  bindAll: ->
    @add_to_cart_form.on 'ajax:success', (e, resp) => @itemAdded(resp)

  itemAdded: (markup) ->
    @cart_container.html($(markup).html())
      # Allow app to update cart handlers when content updated
      .trigger('updated.glysellin')

# Expose through jQuery plugin
$.fn.glysellinProduct = ($cart_container) ->
  @each ->
    $this = $(this)
    data = $this.data('glysellin-product')
    # Avoid multiple initialization
    unless data
      product = new GlysellinProduct($(this), $cart_container)
      $this.data('glysellin-product', product)
