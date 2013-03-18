class AsyncCart
  constructor: (@container) ->
    @defaultPostOptions = {
      _method: @container.find('input[name="_method"]').val(),
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

    @adjustmentRow = @container.find('.adjustment-row')
    @adjustment = {
      name: @adjustmentRow.find('.adjustment-name'),
      value: @adjustmentRow.find('.adjustment-value')
    }

    @discountCode = @container.find('#discount_code')

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

    @container.on "submit", (e, force = false) -> console.log("tuff"); force

    @container.find("[name=submit_order]").on "click", (e) =>
      console.log(e)
      if e.clientX != 0 && e.clientY != 0
        @container.trigger("submit", [true])

  handleEnterKey: (e) ->
    $(e.currentTarget).trigger('change') if e.which == 13
    false

  quantityChanged: (el) ->
    $el = $(el)
    @update(
      'update-quantity',
      { product_id: $el.data('id'), quantity: $el.val() }
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

    @container.trigger('quantity-updated.glysellin')

  discountCodeUpdated: ->
    @update(
      'update-discount-code'
      { discount_code: @discountCode.val() }
      (resp) => @remoteAdjustmentUpdated(resp)
    )

  resetDiscountCode: ->
    @update(
      'update-discount-code'
      { discount_code: '' }
      (resp) => @remoteAdjustmentUpdated(resp)
    )

  remoteAdjustmentUpdated: (resp) ->
    discount = resp.adjustment_name
    if discount
      @subtotalsRow.fadeIn(200)
      @adjustmentRow.fadeIn(200)
    else
      @subtotalsRow.fadeOut(200)
      @adjustmentRow.fadeOut(200)

    # Total row handling
    @setTotals(resp)

    @container.trigger('discount-updated.glysellin', [discount])

  update: (action, options, callback) ->
    $.post(
      "/shop/cart/#{ action }",
      $.extend({}, @defaultPostOptions, options),
      callback,
      'json'
    )

  setTotals: (totals) ->
    @adjustment.name.text(totals.adjustment_name)
    @adjustment.value.text(totals.adjustment_value)
    @subtotals.eot.text(totals.eot_subtotal)
    @subtotals.total.text(totals.subtotal)
    @totals.eot.text(totals.total_eot_price)
    @totals.total.text(totals.total_price)

$.fn.glysellinAsyncCart = (options = {})->
  @each ->
    $cart = $(this)
    data = $cart.data('glysellin.async-cart')
    unless data
      $cart.data('glysellin.async-cart', new AsyncCart($cart, options))