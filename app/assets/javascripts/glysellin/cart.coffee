class GlysellinCart
  defaults =
    onUpdated: null

  constructor: (@container, options) ->
    @options = $.extend({}, defaults, options)
    @add_to_cart_forms = $('[data-add-to-cart-form]')
    @bindAll()

  bindAll: ->
    @add_to_cart_forms.on 'ajax:success', (e, resp) =>
      @update(resp)

  update: (markup) ->
    $markup = $(markup)
    $cart = $markup.find('.cart-container')
    $warning = $markup.find('.added-to-cart-warning').remove()

    @container.html($cart.html())

    if $warning.length > 0
      $warning.appendTo('body')

    @updated()

  updated: ->
    # Allow app to update cart handlers when content updated
    @container.trigger('updated.glysellin')
    # Trigger update callback if passed
    @options.onUpdated(this) if $.isFunction(@options.onUpdated)

$.fn.glysellinCart = (options) ->
  @each ->
    $cart = $(this)
    data = $cart.data('glysellin.cart')
    $cart.data('glysellin.cart', new GlysellinCart($cart, options)) unless data