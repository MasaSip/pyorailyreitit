# pyorailyreitit

Kinect application that interactively visualizes convenience of cycling routes

## Installation

Clone this repository:
	
	git clone git@github.com:atanasi/pyorailyreitit.git

Download ReittiopasAPI user

	https://drive.google.com/drive/folders/0BzfcG6l7ksk2YlRfZ0kxSUVEbHM

and save it in the folder:

	reittiopasRequest

Using reittiopasRequest requres to have HTTP-Request for Processing and Open Kinect for Processing libraries installed
  
## Running the application

	Onniopas/Onniopas.pde

Route data is read from Onniopas/data/routes.txt

## Requesting and analysing route data

Run 

	reittiopasRequest/reittiopasRequest.pde
  
to request a route from reittiopasAPI. The route is saved to reittiopasRequest/output.txt

Run
  
	RouteLoader/RouteLoader.pde

to analyze routes from json files at RouteLoader/data, routes are saved to Onniopas/data/routes.txt

## Instructions for keyboard usage

CTRL to confirm
ALT to return
use mouse to hoover your choise
SHIFT to choose

