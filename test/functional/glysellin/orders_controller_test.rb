require 'test_helper'

module Glysellin
  class OrdersControllerTest < ActionController::TestCase
    test "should get cart" do
      get :cart
      assert_response :success
    end
  
    test "should get fill_address" do
      get :fill_address
      assert_response :success
    end
  
    test "should get recap" do
      get :recap
      assert_response :success
    end
  
    test "should get payment" do
      get :payment
      assert_response :success
    end
  
    test "should get gateway_response" do
      get :gateway_response
      assert_response :success
    end
  
    test "should get payment_response" do
      get :payment_response
      assert_response :success
    end
  
  end
end
