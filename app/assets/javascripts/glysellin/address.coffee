class GlysellinAddress
  defaults =
    onUpdated: null

  constructor: (@container) ->
    @shipping_address_container = @container.find('.shipping-address-container')
    @billing_address_container = @container.find('.billing-address-container')
    @toggle_shipping_address = @container.find('[data-toggle="address"]')
    @bindAll()

  bindAll: () ->
    @toggle_shipping_address.on "change", =>
      @switchAddress()

  switchAddress: () ->
    if @toggle_shipping_address.is(':checked')
      @shipping_address_container.show()
      
      for attr in ['first_name', 'last_name', 'address', 'zip', 'city', 'tel']
        if @shipping_address_container.find("[name*='[#{ attr }]']").val() == ""
          @shipping_address_container.find("[name*='[#{ attr }]']").val(@billing_address_container.find("[name*='[#{ attr }]']").val())
      
      # Country
      val = @billing_address_container.find("[name*='country']").val()
      if @shipping_address_container.find("[name*='country']").val() == ""
        @shipping_address_container.find("[name*='country']").val(val)
        @shipping_address_container.find("[name*='country']").change()
    else
      @shipping_address_container.hide()
  
$.fn.glysellinAddress = () ->
  @each ->
    address = new GlysellinAddress($(this))
    address.switchAddress() 
