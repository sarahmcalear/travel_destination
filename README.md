# Travel Destination App

## [Travel Destination](http://travel-destination.herokuapp.com/destinations)

## Description

>This app allows people who love to travel to come up with more ideas for future trips. It helps organize trips and find destinations that one might have never been to. This information can be stored, reviewed, and edited at a later time.

## User Stories

### Project Sprint

##### As a User...

1. I can log in
1. I can log out
1. when I log in, I can see all destinations I've previously saved
1. I can search for a specific city/destination
1. I can have the app display a random destination
1. I can click on saved destinations and see the details about this destination
1. I can save attractions/restaurants, etc to a destination
1. I can remove destinations
1. I can remove attractions saved to my destinations
1. I can create my own notes about a destination
1. I can edit the notes I created about a destination
1. I can delete notes I created about a destination
1. I can view pictures of a destination
1. I can view restaurants of a destination
1. I can view information pertinent to travelling
	1. exchange rate
	1. distance




### Icebox

##### As a User...

1. I can shart destinations with others
1. I can listen to music from the destination
1. I can find flight information
1. I can find airport information
1. I can find hotel information
1. I can find rent a bike information


## For Copying:

#### Gems/APIs/Frameworks used:

* bcrypt gem - for authentication of users
* geocoder gem - for geolocation of places
* uri gem - to build query params
* httparty gem - to create connections to APIs
* google place api - to add in information about restaurants and other places to visit in a specific area [click here to see the Google Place API](https://developers.google.com/places/documentation/)
* Wolfram Alpha API - eventually to retrieve additional information about the location entered [click here to see the Wolfram Alpha API documentation](http://products.wolframalpha.com/api/)
* Panoramio API - to get pictures of the area [click here to see the Panoramio API](http://www.panoramio.com/api/widget/api.html)
* Materialize - to style the page [click here to view](http://materializecss.com/)
* Sweet Alert - for pretty pop ups [click here to view](http://tristanedwards.me/sweetalert)

## Instructions to run the App

Clone the Repo and cd into it

  $ git clone git@github.com:sarahmcalear/travel_destination.git
  $ cd travel_destination

  To run this App, a Google Place API key is required.

  Now install the required Gems, rake db:setup, and start up your app in Terminal.

  $ bundle install
  $ rake db:setup
  $ rails s puma


