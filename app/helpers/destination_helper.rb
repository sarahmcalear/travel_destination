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

  # types = "food|cafe|bar|night_club|casino|spa|zoo|aquarium|stadium|museum".split("|")
  # types.each do |type|
  #   define_method "sort_by_#{type}"(information) do
  #      type
  #     type = information.select do |place|
  #       place["types"].include? type
  #     end
  #     if "#{type}s" != []
  #       sorted_"#{type}s" = "#{type}s".sort_by {|this_type| this_type["rating"]}.reverse
  #     else
  #       sorted_"#{type}s" = []
  #     end
  #   end
  # end

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
 #    information = ({"html_attributions"=>["Listings by <a href=\"http://www.gelbeseiten.de/\">GelbeSeiten®Verlagen</a>"],
 # "results"=>
 #  [{"geometry"=>{"location"=>{"lat"=>50.069555, "lng"=>8.646306}},
 #    "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/stadium-71.png",
 #    "id"=>"8c22dcb710023133ec0755729f6235584b6f1530",
 #    "name"=>"Commerzbank-Arena",
 #    "photos"=>
 #     [{"height"=>828,
 #       "html_attributions"=>[],
 #       "photo_reference"=>
 #        "CnRnAAAACqH2v3aKBV7nx3ETXU39tTULVEMefKWQ58M-Nm4fLLuPwiQfqmT1mHbVn8FK0cGcXYlwhEoGGtovjN4O4m95y_65jQw_0ZfF6verIarjXf6lktERWq9IPwdhWYbDGewKAr6oGQ9YbaK_6d2MSulx4RIQobi0-WDxqilbmdpBB7qEoxoUIjQ1-XAU8zVmIgV1SHwy_KHCgFw",
 #       "width"=>1500}],
 #    "place_id"=>"ChIJ4YZAN4ILvUcRCpwnOJut73I",
 #    "rating"=>4.8,
 #    "reference"=>
 #     "CnRkAAAApSwZrvHGLWokwKkaQe1uDANbnF_eZxmu8eS9NvhEwIJiwO8IAEEvq6EBSnGlktAMxbxQVv62KPxDD0B4EsVd5d0nm1HQm-vlan-C7-2UWXrtzRSO8Oc41zwW5Y-QeP0iYgR1coZ2CSfrmcEg2eXlrRIQpfXI3ngPDSHFvG1eP3BvlhoUQWSMUPWpa2mAHAIELm_S729WcZM",
 #    "scope"=>"GOOGLE",
 #    "types"=>["stadium", "establishment"],
 #    "vicinity"=>"Mörfelder Landstraße 362, Frankfurt am Main"},
 #   {"geometry"=>{"location"=>{"lat"=>50.117539, "lng"=>8.651744}},
 #    "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png",
 #    "id"=>"c1111793b06b9c1e1ea8179e08a718a5d5351645",
 #    "name"=>"Naturmuseum Senckenberg",
 #    "opening_hours"=>{"open_now"=>false, "weekday_text"=>[]},
 #    "photos"=>
 #     [{"height"=>1094,
 #       "html_attributions"=>["From a Google User"],
 #       "photo_reference"=>
 #        "CrQCMAEAAOLRfKiwESgIK_Wi1PtW1rRLiUsO-pDQz5Mvn-7sh08zTWOdTTxrDSgNPSrt9G0_aeOGA2yJygSRak8qAzxwGomSbSeOXM286VVuyVMIIAJgE6RocTzl3wSANW5prCmusUXMAL-qX_fyfGTArNOrdT_SeXl91VYPGY9mPU3ciW4C2DsYXP9hhlMbi1WAPFPInPjtmi39ZPcJqXdz7uqF-lhipM_2z5hvDIpTMxE8-yVx3EK3Z8HJqv4fuHqJVI3_xGo-RzhxYOlETDKcjyqorPw78__fh6R4uoepf7bxGJ0coHNTinVNyxeQgnur_6nEx0RwkcHbzAj05oitVICq98PTOqdbcVE22aJEu4Za67GVrf0oZqDvZP1tJ4sX_diSmrOEfCMLLpK8XmDTAlMLs8oSENsm1ayyCQ3Kp6zg2hmzB-MaFK7x66BMt5SlV3lT0_ZI-2i8evo-",
 #       "width"=>1459}],
 #    "place_id"=>"ChIJ2V1QFlsJvUcRSRhgQZzHGNA",
 #    "rating"=>4.4,
 #    "reference"=>
 #     "CnRrAAAAW62EbSM8-Qnp4kY_fsAVeb7v5ktkv8u-MpT_4uJmUkHYZ6WeHFq0vjgfDeppZAOKGiPROSeeudlYntUsIu4PeGwITAeh7Yfqo-ZINM4csdvHqbOT0kkW5k5rEVV50gTxoe0XKLfvewLfqmm-18LSYRIQ48pdCovK6tIdMxh2VUlKohoU4_EMk2jxc8o_dr9SuzDqQW8NNqk",
 #    "scope"=>"GOOGLE",
 #    "types"=>["museum", "establishment"],
 #    "vicinity"=>"Senckenberganlage 25, Frankfurt am Main"},
 #   {"geometry"=>{"location"=>{"lat"=>50.103092, "lng"=>8.674058}},
 #    "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/art_gallery-71.png",
 #    "id"=>"5a8f6f17e251b2e343371d2e200da76093523e78",
 #    "name"=>"Städel",
 #    "opening_hours"=>{"open_now"=>false, "weekday_text"=>[]},
 #    "photos"=>
 #     [{"height"=>1028,
 #       "html_attributions"=>[],
 #       "photo_reference"=>
 #        "CnRnAAAAiJa2W_-JUwQCmlpFmcCQ4e2_KP8FQiLrnvCFG6dLewom2Sh6_l_5bIVoXLclGVPbFFsW6JvuL9F1U1IrjbLf3Dhulychay8hlLcHaQvILyU_Cl4nEcmaB0JViShj1DKMSQj1YIl6AL6jdTK7SpNlJhIQO2y1UdieUdHcBPrPN1UiqRoUOdCx8QcHVukkZa3nHkVU-7Alugw",
 #       "width"=>2048}],
 #    "place_id"=>"ChIJ61K7owMMvUcRn_SCURQ0DaE",
 #    "rating"=>4.3,
 #    "reference"=>
 #     "CmRbAAAA1wqPvj6qKOwz7AYRlksbvx0FMgyQKVH3eP0oiGre_OXqsNu5ECHo-6V65jcIeoOCjBlRbDTQRiOqicmWmqBPceoXLamTL8Ct0FBQwvlZPSL-7zm68-jY7BYiGy_ER6TyEhAeqZ2XaEOyXU6o20AZc64lGhSQ6gCH6Pcczf2FeQ4JPF-Ufrvh8Q",
 #    "scope"=>"GOOGLE",
 #    "types"=>["art_gallery", "museum", "establishment"],
 #    "vicinity"=>"Schaumainkai 63, Frankfurt am Main"},
 #   {"geometry"=>{"location"=>{"lat"=>50.108024, "lng"=>8.672781}},
 #    "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
 #    "id"=>"32b89847e7e1f1eb0feedfe9c4b5af8643e3446d",
 #    "name"=>"CHICAGO MEATPACKERS",
 #    "opening_hours"=>{"open_now"=>true, "weekday_text"=>[]},
 #    "photos"=>
 #     [{"height"=>567,
 #       "html_attributions"=>[],
 #       "photo_reference"=>
 #        "CnRnAAAA6EflUAmWUinAkUhO1k35VzTVLfk_WlW_NygPXWXfkTtyDlhNQHkHro3g24xaAjraDj4NTVrp5Dw-Da9KBsIAOpbHC1IG3xO8Icp-GMN6xqOkDUWu36l-_rQGTzOqbxX2BwlFt7An4a9Gqv2ni8fIaxIQzdZV0H4IHppf5tX7YN5RABoU0ilg-uXSgs4K-6LXkgpl_R3J9Tg",
 #       "width"=>376}],
 #    "place_id"=>"ChIJ8cPUIqoOvUcR4-ZbON24lOY",
 #    "price_level"=>1,
 #    "rating"=>3.8,
 #    "reference"=>
 #     "CnRnAAAAUy0WqFxun1UrvzBlw4NGoRDhWBRD17_DfywE8sYJ_kgB2n4VgFpkxKlNHQExB0jNmDaKr8MgI71g7VushsUdHxBieBGQUyVZBmypwSMbHW-3k7pADhkTaeSAGlbu6dG89PhVq6XYMm44BS8e4lkbHRIQ8B5fWNjzVsk7nKpXivvh_BoUgfaEebRLPj17lqP96jV1Zivf2mM",
 #    "scope"=>"GOOGLE",
 #    "types"=>["restaurant", "food", "establishment"],
 #    "vicinity"=>"Untermainanlage 8, Frankfurt am Main"},
 #   {"geometry"=>{"location"=>{"lat"=>50.105734, "lng"=>8.66615}},
 #    "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png",
 #    "id"=>"169ec2fd5325904c8106adc0fdb87b1208683fab",
 #    "name"=>"Le Méridien Parkhotel Frankfurt",
 #    "opening_hours"=>{"open_now"=>true, "weekday_text"=>[]},
 #    "photos"=>
 #     [{"height"=>500,
 #       "html_attributions"=>[],
 #       "photo_reference"=>
 #        "CsQBuwAAAGFMTm5EoaZdo6oAFNZykahG6Bn4nSv-gr2RNzdX11uTmwDLwrmAKOc15oU4vi0FmTEfGtPMwcqcdetp6SY50SPTMORQrbCpsF_95tGqmpmiVJH9hwkn8JB9ZofX92TjNh_zKdJRFkvtv-4J7LhTl715zPkI6M9VxHNyfXOKpIYoVHSkIfOrE-6-FigtYqVAnaetgzr_JHPlVAJi_TnK8NOarqigUZfYksa1dQmian6XDHqYiQnGnVJxtLtYc-Ua6RIQrzAFxUIBqtMV7iOu4NMVphoUiaxZPwveMjHqabUN_cN2QI-KVoY",
 #       "width"=>500}],
 #    "place_id"=>"ChIJPYVkdgAMvUcRujFXhQpZBkg",
 #    "rating"=>4.1,
 #    "reference"=>
 #     "CoQBcwAAAK4PBuwziIGxAujYNJ39MIWzw5I6HTJogBWielMQ9r0tO-Z5kqw2cQiib_sW9uzVsC1265WWTOydsPotDlbQDGWCwe5bnv1yGHvkL5JC7Yf5v6hQtOcusFwGk1z0qKoEaaW9Ov4qwr1u1QwA34S4DmQARmAF4fRU2aaLlgTvrXfPEhA_QrqFd6t9ZlgFoil30OObGhR-6LIEit9ckIoCyEc96RBZrLEPEA",
 #    "scope"=>"GOOGLE",
 #    "types"=>["bar", "restaurant", "lodging", "food", "establishment"],
 #    "vicinity"=>"Wiesenhüttenplatz 28-38, Frankfurt am Main"},
 #   {"geometry"=>{"location"=>{"lat"=>50.107174, "lng"=>8.674438}},
 #    "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png",
 #    "id"=>"ce92c9a53603eb9ea2dacb663e71592773e8f458",
 #    "name"=>"Jüdisches Museum",
 #    "opening_hours"=>{"open_now"=>false, "weekday_text"=>[]},
 #    "photos"=>
 #     [{"height"=>1462,
 #       "html_attributions"=>["From a Google User"],
 #       "photo_reference"=>
 #        "CoQBfQAAAO8dCmYlby-eY-Csv5N0OO0_RK4aEDXtOOd-QwhF-su4ewmfuSqLjqPdwLNv-wzUn2YyiuM1ftR1FE4bOx8GfM_Yaafgh9u9YVRDBuHM-wi51xMXMNX15t0TkhhGfBZF5X64wjG5ARU1s5divuCoVCdIfPH3GUDIiqRjDyaNxJ0lEhCfdhzVNov6R-14S2s1izdWGhSOj5ILHxf0_1b7WHuhM78bbyiCjQ",
 #       "width"=>2048}],
 #    "place_id"=>"ChIJWXz64KkOvUcRkLMDDCsGK4Y",
 #    "rating"=>3.5,
 #    "reference"=>
 #     "CnRlAAAAyXN4W6Q1wFWg9oPd1xKwKHDLYJsFbSJaPV30vJEMdKJR9XF_aKs8tGp00z8HbC0lKzhVKDgYoPJX4yTEkkh577Ptrz98a_2q5Vf9Pptasp9dx3lAmo4xQ_MJ34pbi7qDf_XATC-7R6lptFiUd8AuUBIQh9YcaymmRpa2m9NKSBJwURoU7lDWj8ivLVPNZ2Y6lVPtXCFV5ng",
 #    "scope"=>"GOOGLE",
 #    "types"=>["museum", "establishment"],
 #    "vicinity"=>"Untermainkai 14/15, Frankfurt am Main"},
 #   {"geometry"=>{"location"=>{"lat"=>50.10523, "lng"=>8.677677}},
 #    "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png",
 #    "id"=>"a33c37161a4260b6df27a858da2a43ffe18d79b9",
 #    "name"=>"Deutsches Filmmuseum",
 #    "opening_hours"=>{"open_now"=>false, "weekday_text"=>[]},
 #    "photos"=>
 #     [{"height"=>504,
 #       "html_attributions"=>["From a Google User"],
 #       "photo_reference"=>
 #        "CnRjAAAADdGHxy9WSxokQjHcmRthC0RU5Ihsj45t0Qzpf1p3B3xEvQ97wpjwn_9LsJ5KqEZ5gfEL913YMrTJXN7qcmqwQmEltUn4JuPxPScB3E59LXw5V2T0kiR_MKEqKGbQ8SM-i-cG2-3OPSyvLiuhEK8SrRIQ8e0a6csm3vVPnO1THk-13xoUwbwoVJeMrKempYi1aXBlJ70r1Js",
 #       "width"=>769}],
 #    "place_id"=>"ChIJe085wAIMvUcRd0Cw1cpnWo8",
 #    "rating"=>4.3,
 #    "reference"=>
 #     "CnRoAAAAGpLmtyw_oe9sxrFhY21Qg5N_-FmoL5HtLottedky5D2Wco-TyMB-lQShQS_kbZut-_3XHCE-NZIKcOlojyrwnxW7W5cwYotUf8Dc0fLOpASrsYzIwWoHp5jHWPtH_ovQkawR5WZifVZ4cYxKDfAc_xIQhm4waO07mzKA8ZZ29jLxMxoU1Swe7slJAb-mY4VMOlTepHCDYVs",
 #    "scope"=>"GOOGLE",
 #    "types"=>["museum", "movie_theater", "establishment"],
 #    "vicinity"=>"Schaumainkai 41, Frankfurt am Main"},
 #   {"geometry"=>{"location"=>{"lat"=>50.115394, "lng"=>8.647803}},
 #    "icon"=>"http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png",
 #    "id"=>"3509fd8195b17c94c2d08b1f6d5e7fcac5dddac8",
 #    "name"=>"EXPERIMINTA ScienceCenter FrankfurtRheinMain",
 #    "opening_hours"=>{"open_now"=>false, "weekday_text"=>[]},
 #    "photos"=>
 #     [{"height"=>1080,
 #       "html_attributions"=>[],
 #       "photo_reference"=>
 #        "CnRnAAAAU5dwizR-i5RNkI99X98JvXF-q6xCAHD7YBS8WvsWga1PB1r8IvYxXLtMUPU7-8sEC2TU6iFWC5wYG8N1U3uV800Zw9B6vDkiytnU8ht-Eaq_vXeulbA3-itWdfQlquDFoE4o9mOB_mIoiXpBJldSgRIQjlzBQ131WniwiNQ0YYflxBoU-rH5AK2iyqzXwALy8mKJTfe7N9E",
 #       "width"=>1440}],
 #    "place_id"=>"ChIJCdh4bFwJvUcRLJz_4weaZEg",
 #    "rating"=>3.9,
 #    "reference"=>
 #     "CoQBfwAAAGdZdSAB5Xgu-F4ddNqIBdEqaD_xK2b4aerMAsyXXZC3Pzw3oLREEX2t8hZAaYVEeFvJvV_tHuSBrBPbJXnMD1wekG6s6_ZAlIbThH7IYldGd2-nev8SC6z4y5recz7V9SqbvxmRHPmZTFpfbs4XueAl_Nde53neILNxGL0yOegmEhDPHKM8PvfTpPC2wp31Gl0cGhQTAmxHMHbD_bPQlsnyQFJiOk8MPw",
 #    "scope"=>"GOOGLE",
 #    "types"=>["museum", "establishment"],
 #    "vicinity"=>"Hamburger Allee 22-24, Frankfurt am Main"}],
 # "status"=>"OK"})
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

