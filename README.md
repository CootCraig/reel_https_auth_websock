reel_https_auth_websock
=======================

Proof of concept for Raspberry Pi based Reel home automation gateway

## Motivation

The goal is a wireless control system for outside lights at home.

I am planning to use Modeino hardware.
Feix at LowPowerLab has documented a
Raspberry Pi home automation gateway on his blog

* [RaspberryPi home automation gateway – Intro](http://lowpowerlab.com/blog/2013/10/02/raspberrypi-home-automation-gateway/)
* [RaspberryPi home automation gateway – Approach](http://lowpowerlab.com/blog/2013/10/03/raspberrypi-home-automation-gateway-approach/)
* [RaspberryPi home automation gateway – Hardware and Demo](http://lowpowerlab.com/blog/2013/10/11/raspberrypi-home-automation-gateway-hardware-and-demo/)

His diagram

![Low Power Lab Gateway diagram](/images/felix_gateway_diagram.png "Low Power Lab Gateway")

## Felix Big Picture

[From the home automation gateway – Intro](http://lowpowerlab.com/blog/2013/10/02/raspberrypi-home-automation-gateway/)

Ok so let’s get the 10,000 ft picture…

### Authorization.

We need to only allow authorized access to the home
gateway. So whoever hits the gateway needs to provide authorization tokens

### Encryption.

We need HTTPS, period.

### Realtime.

To have any kind of real time feel interacting with your home
automation gateway, you will need __websockets.__

### RaspberryPi powered.

It’s because Rpi is the other cool thing of the
day. It’s powerful enough to run a fast webserver, a websocket server,
perhaps a database to log your data, and host your wireless Moteino
gateway, or whatever else you might interface to your IoT stuff. I want
ONE central Rpi, not a dozen.

## My Approach

This first demonstration will run on a Raspberry Pi,
but will have no hardware specific components.

### Use Jruby/Celluloid/Reel for the HTTP server.

* Reel supports https.
* Reel supports websockets.

For authorization, I plan to manage an authorization cookie
in the browser withJavaScript.  Login/password pairs will be
stored in a config file of the Celluloid/Reel application for now.

### Functionally

* HTTP server will run on a Raspberry Pi and start at boot time.
* Demonstrate https.
* Unauthorized access will be redirected to a login page. A cookie will store authorization.
* Demonstrate a websocket that updates with server time.


