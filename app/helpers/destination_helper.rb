module DestinationHelper
  require 'uri'

  def find_latitude_and_longitude(search)
    location = Geocoder.search(search)[0]
    {latitude: location.latitude, longitude: location.longitude}
  end

  def generate_google_api_link(geolocation)
    query_params = "?" + URI.encode_www_form({
      location: geolocation[:latitude] + "," + geolocation[:longitude],
      types: "food",
      radius: 5000,
      key: ENV["GOOGLE_BROWSER_API_KEY"]
      })
    "https://maps.googleapis.com/maps/api/place/nearbysearch/json" + query_params
  end

end

