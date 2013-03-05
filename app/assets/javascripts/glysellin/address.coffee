class GlysellinAddress
  defaults =
    onUpdated: null

  constructor: (@container, model) ->
    @toggle_shipping_address = $("#glysellin_order_use_another_address_for_shipping")
    @bindAll(model)

  bindAll: (model) ->
    @toggle_shipping_address.on "change", =>
      @switchAddress(model)

  switchAddress: (model)->
    if @container.hasClass("collapse")
      @container.removeClass "collapse"
      for attr in ['first_name', 'last_name', 'address', 'zip', 'city', 'tel']
        $("##{ model }_shipping_address_attributes_#{ attr }").val($("##{ model }_billing_address_attributes_#{ attr }").val())
      console.log model
      #Country
      val = $("##{ model }_billing_address_attributes_country option:selected").val()
      $("##{ model }_shipping_address_attributes_country option:selected").removeAttr('selected')
      $("##{ model }_shipping_address_attributes_country option[value='#{ val }']").attr('selected', 'selected')
      $("##{ model }_shipping_address_attributes_country").change()
    else
      @container.addClass "collapse"

$.fn.glysellinAddress = (options) ->
  @each ->
    new GlysellinAddress($(this), options)
