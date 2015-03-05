module DestinationHelper
  require 'uri'

  def find_latitude_and_longitude(search)
    location = Geocoder.search(search)[0]
    {latitude: location.latitude, longitude: location.longitude}
  end

  def generate_google_api_link(geolocation)
    query_params = "?" + URI.encode_www_form({
      location: "#{geolocation[:latitude]} , #{geolocation[:longitude]}",
      types: "food|cafe|bar|night_club|casino|spa|zoo|aquarium|stadium|museum",
      radius: 5000,
      key: ENV["GOOGLE_BROWSER_API_KEY"]
      })
    "https://maps.googleapis.com/maps/api/place/nearbysearch/json" + query_params
  end


  # def sort_info_by_category(information)
  #   types = "food|cafe|bar|night_club|casino|spa|zoo|aquarium|stadium|museum".split("|")
  #   types.each do |type|
  #     define_method "sort_by_#{type}" do
  #        type
  #       type = information.select do |place|
  #         place["types"].include? type
  #       end
  #       if "#{type}s" != []
  #         sorted_"#{type}s" = "#{type}s".sort_by {|this_type| this_type["rating"]}.reverse
  #       else
  #         sorted_"#{type}s" = []
  #       end
  #     end
  #   end
  #   {restaurants: sorted_foods, cafes: sorted_cafes, bars: sorted_bars, spas: sorted_spas}
  # end

  def sort_info_by_category(information)
    spas = information["results"].select do |place|
      place["types"].include? "spa"
    end
    if spas != []
      sorted_spas = spas.sort_by {|spa| spa["rating"]}.reverse
    else
      sorted_spas = []
    end
    bars = information["results"].select do |place|
      place["types"].include? "bar"
    end
    if bars != []
      sorted_bars = bars.sort_by {|bar| bar["rating"]}.reverse
    else
      sorted_bars = []
    end
    restaurants = information["results"].select do |place|
      place["types"].include? "food"
    end
    if restaurants != []
      sorted_restaurants = restaurants.sort_by {|restaurant| restaurant["rating"]}.reverse
    else
      sorted_restaurants = []
    end
    cafes = information["results"].select do |place|
      place["types"].include? "cafe"
    end
    if cafes != []
      sorted_cafes = cafes.sort_by {|cafe| cafe["rating"]}.reverse
    else
      sorted_cafes = []
    end
    family_entertainment = information["results"].select do |place|
      (place["types"].include? "zoo") || (place["types"].include? "aquarium") || (place["types"].include? "stadium") || (place["types"].include? "museum")
    end
    if family_entertainment != []
      sorted_family_entertainment = family_entertainment.sort_by {|entertainment| entertainment["rating"]}.reverse
    else
      sorted_family_entertainment = []
    end
    entertainment = information["results"].select do |place|
      (place["types"].include? "night_club") || (place["types"].include? "casino")
    end
    if entertainment != []
      sorted_entertainment = entertainment.sort_by {|entertainment| entertainment["rating"]}.reverse
    else
      sorted_entertainment = []
    end
    {restaurants: sorted_restaurants, cafes: sorted_cafes, bars: sorted_bars, spas: sorted_spas, family_entertainment: sorted_family_entertainment, entertainment: sorted_entertainment}
  end

  def retrieve_info_from_google(search)
    geolocation = find_latitude_and_longitude(search)
    link = generate_google_api_link(geolocation)
    information = HTTParty.get(link)
    info = sort_info_by_category(information)
  end

end

