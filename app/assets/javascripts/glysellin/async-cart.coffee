class AsyncCart
  constructor: (@container) ->
    @defaultPostOptions = {
      utf8: @container.find('input[name="utf8"]').val(),
      authenticity_token: @container.find('input[name="authenticity_token"]').val()
    }

    $totalRow = @container.find('.products-total-row')
    @totals = {
      eot: $totalRow.find('.total-eot-price')
      total: $totalRow.find('.total-price')
    }

    @subtotalsRow = @container.find('.products-subtotal-row')
    @subtotals = {
      eot: @subtotalsRow.find('.eot-subtotal'),
      total: @subtotalsRow.find('.subtotal')
    }

    @adjustmentRow = @container.find('.adjustment-row[data-type=discount-code]')
    @adjustment = {
      name: @adjustmentRow.find('.adjustment-name'),
      value: @adjustmentRow.find('.adjustment-value')
    }

    @discountCode = @container.find('#glysellin_cart_basket_discount_code')

    @cart_path = @container.data("cart-url")

    @bindAll()

  bindAll: ->
    @container.find('.quantity-input')
      .on('change', (e) => @quantityChanged(e.currentTarget))
      .on 'keyup', (e) =>
        @handleEnterKey(e)

    @discountCode.on 'keyup', (e) =>
      @handleEnterKey(e)

    @container.find('.update-discount-code-btn').on 'click', (e) =>
      @discountCodeUpdated()

    @discountCode.on 'change', (e) =>
      @discountCodeUpdated()

    @adjustmentRow.find('.remove-discount-btn').on 'click', (e) =>
      @resetDiscountCode(); false

    @container.on "submit", (e, force = false) -> force

    @container.find("[name=submit_order]").on "click", (e) =>
      if e.clientX != 0 && e.clientY != 0
        @container.trigger("submit", [true])

  handleEnterKey: (e) ->
    $(e.currentTarget).trigger('change') if e.which == 13
    false

  quantityChanged: (el) ->
    $el = $(el)
    quantity = parseInt($el.val(), 10)

    # Ensure we have an int > 0 or use 1
    unless $.isNumeric(quantity) && quantity > 0
      quantity = 1
      $el.val(quantity)

    @update(
      "products/#{ $el.data('id') }",
      { _method: "put", quantity: quantity}
      (resp) => @remoteQuantityUpdated(resp, $el)
    )

  remoteQuantityUpdated: (resp, $el) ->
    # Current product row update handling
    $tr = $el.closest('tr')
    $el.val(resp.quantity)
    $tr.find('.product-eot-price').text(resp.eot_price)
    $tr.find('.product-price').text(resp.price)

    # Total row handling
    @setTotals(resp)
    @setDiscountValues(resp)

    @container.trigger('quantity-updated.glysellin')

  discountCodeUpdated: ->
    @update(
      "discount_code"
      { _method: "put", code: @discountCode.val() }
      (resp) => @remoteAdjustmentUpdated(resp)
    )

  resetDiscountCode: ->
    @update(
      'update-discount-code'
      { _method: "put", code: '' }
      (resp) => @remoteAdjustmentUpdated(resp)
    )

  remoteAdjustmentUpdated: (resp) ->
    discount = resp.discount_name
    if discount
      @setDiscountValues(resp)
      @subtotalsRow.fadeIn(200)
      @adjustmentRow.fadeIn(200)
    else
      @subtotalsRow.fadeOut(200) unless $('.adjustment-row').length > 1
      @adjustmentRow.fadeOut(200, => @setDiscountValues(resp))

    # Total row handling when
    @setTotals(resp)

    @container.trigger('discount-updated.glysellin', [discount])

  update: (action, options, callback) ->
    $.post(
      "#{ @cart_path }/#{ action }",
      $.extend({}, @defaultPostOptions, options),
      callback,
      'json'
    )

  setDiscountValues: (totals) ->
    @adjustment.name.text(totals.discount_name)
    @adjustment.value.text(totals.discount_value)

  setTotals: (totals) ->
    @subtotals.eot.text(totals.eot_subtotal)
    @subtotals.total.text(totals.subtotal)
    @totals.eot.text(totals.total_eot_price)
    @totals.total.text(totals.total_price)

$.fn.glysellinAsyncCart = (options = {})->
  @each ->
    $cart = $(this)
    data = $cart.data('glysellin.async-cart')
    $cart.data('glysellin.async-cart', new AsyncCart $cart, options) unless data
