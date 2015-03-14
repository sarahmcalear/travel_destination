module DestinationHelper
  require 'uri'
  extend DestinationHelper


  def find_latitude_and_longitude(search)
    location = Geocoder.search(search)[0]
    {latitude: location.latitude, longitude: location.longitude}
  end

  def generate_google_api_link(geolocation)
    query_params = "?" + URI.encode_www_form({
      location: "#{geolocation[:latitude]} , #{geolocation[:longitude]}",
      types:    "food|cafe|bakery|bar|night_club|casino|spa|zoo|aquarium|amusement_park|park|library|stadium|museum",
      radius:   5000,
      key:      ENV["GOOGLE_BROWSER_API_KEY"]
      })
    # ENV["GOOGLE_KEVIN_API"]
    "https://maps.googleapis.com/maps/api/place/nearbysearch/json" + query_params
  end

  def generate_wolfram_api_link(search)
    query_params = "?" + URI.encode_www_form({
      input: search,
      appid: ENV["WOLFRAM_ALPHA_APP_ID"]
    })
    "http://api.wolframalpha.com/v2/query" + query_params
  end

  def generate_panoramio_api_link(geolocation)
    query_params = "?" + URI.encode_www_form({
      set:      "public",
      from:      0,
      to:        20,
      minx:      geolocation[:longitude] - 1,
      miny:      geolocation[:latitude] - 1,
      maxx:      geolocation[:longitude] +1,
      maxy:      geolocation[:latitude] +1,
      size:      "medium",
      mapfilter: true
      })
    "http://www.panoramio.com/map/get_panoramas.php" + query_params
  end

  def generate_weather_underground_link(geolocation)
    "http://api.wunderground.com/api/" + ENV["WEATHER_UNDERGROUND_API"] + "/forecast/q/" + geolocation[:latitude].to_s + "," + geolocation[:longitude].to_s + ".json"
  end

  # def retrieve_weather_from_wunderground(destination)
  #   geolocation = find_latitude_and_longitude(destination)
  #   link = generate_weather_underground_link(geolocation)
  #   HTTParty.get(link)
  # end


  def sort_info_by_category(information)
    foods = information["results"].select do |place|
      (place["types"].include? "food") || (place["types"].include? "cafe") || (place["types"].include? "bakery") || (place["types"].include? "bar")
    end
    if foods != []
      sorted_foods = foods.sort_by {|restaurant| restaurant["rating"] || 0}.reverse
    else
      sorted_foods = []
    end

    family = information["results"].select do |place|
      (place["types"].include? "zoo") || (place["types"].include? "aquarium") || (place["types"].include? "stadium") || (place["types"].include? "museum") || (place["types"].include? "spa") || (place["types"].include? "amusement_park") || (place["types"].include? "park")
    end
    if family != []
      sorted_family = family.sort_by {|entertainment| entertainment["rating"] || 0}.reverse
    else
      sorted_family = []
    end

    entertainment = information["results"].select do |place|
      (place["types"].include? "night_club") || (place["types"].include? "casino")
    end
    if entertainment != []
      sorted_entertainment = entertainment.sort_by {|entertainment| entertainment["rating"] || 0}.reverse
    else
      sorted_entertainment = []
    end
    {food: sorted_foods, family: sorted_family, entertainment: sorted_entertainment}
  end

  def retrieve_info_from_google(search)
    geolocation = find_latitude_and_longitude(search)
    link = generate_google_api_link(geolocation)
    information = HTTParty.get(link)
    info = sort_info_by_category(information)
  end

  # TODO: optimize this for speed.
  def retrieve_info_from_wolfram(search)
    link = generate_wolfram_api_link(search)
    HTTParty.get(link)
  end

  def retrieve_panoramio_photos(search)
    geolocation = find_latitude_and_longitude(search)
    link = generate_panoramio_api_link(geolocation)
    HTTParty.get(link)
  end

end

