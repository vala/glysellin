# Glysellin

Glysellin is a lightweight e-commerce solution that helps you get simple products, orders and payment gateways without the whole set of functionalities a real e-commerce needs.

It is exposed as a mountable engine so you can customize what you want... doc be written

## Warning !

Glysellin is just adapted for one app for now, it is not usable as is for normal e-commerce purposes


## Gateway integration

The routes to redirect the payments gateways to are :

* For the automatic Server to Server response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/:gateway` where :gateway is the gateway slug
* For the "Return to shop" redirections :
    * Success response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/response/success`
    * Error response : `http://yourapp.com/<glysellin_mount_point>/orders/gateway/response/cancel`