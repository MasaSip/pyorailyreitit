# pyorailyreitit

Kinect application that interactively visualizes convenience of cycling routes

## Installation

Clone this repository:
	
	git clone git@github.com:atanasi/pyorailyreitit.git

Install Open Kinect for Processing library

  
## Running the application

	Onniopas/Onniopas.pde

Route data is read from Onniopas/data/routes.txt, which includes seven pre-analysed routes with different lengths.

## Adding a custom route for Onniopas

Adding a new route includes requesting and pre-analysing the route data. Pre-analysing the routes is separated into a separate RouteLoader -application in order to avoid heavy run time processing of data at Onniopas.

Install HTTP-Request for Processing library.

Save your reittiopasAPI user to reittiopas_user.txt at reittiopasRequest

To request a route from reittiopasAPI, run: 

	reittiopasRequest/reittiopasRequest.pde
  
The route is saved to reittiopasRequest/output.json 

RouteLoader/data contains a collection of unanlyzed routes in json format. To pre-analyze routes, run:
  
	RouteLoader/RouteLoader.pde

pre-analysed routes are saved to Onniopas/data/routes.txt

## Instructions for keyboard usage

CTRL to confirm
ALT to return
use mouse to hoover your choise
SHIFT to choose

