console.log('main.js loaded');
$(document).ready(function(){

  $('.location-search').on('submit', function(event){
    event.preventDefault();
    var searchLocation = $('.location-input').val();
    // contact the database to use ruby gem to find latitude and longitude of the loacation
  //   $.ajax({
  //     url: '/destinations',
  //     dataType: 'json',
  //     type: 'get',
  //     data: {location: searchLocation}
  //   }).success(function(data){
  //     console.log(data);
  //   }).error(function(error){
  //     sweetAlert("Oops...", "Something went wrong!", "error");
  //     console.log("Status Code: "+error.status);
  //     console.log("Status Text: "+error.statusText);
  //   })
  console.log(searchLocation);
  })


})
