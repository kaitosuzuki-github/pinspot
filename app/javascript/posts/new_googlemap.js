let map;
let geocoder;
let marker;
let lat = document.getElementById("lat");
let lng = document.getElementById("lng");

function initMap() {
  map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 36.204824, lng: 138.252924 },
    zoom: 5,
  });
  geocoder = new google.maps.Geocoder();
}

function codeAddress() {
  if (marker != null) {
    marker.setMap(null);
  }
  let inputAddress = document.getElementById("address").value;
  geocoder.geocode({ address: inputAddress }, function (results, status) {
    if (status == "OK") {
      map.setCenter(results[0].geometry.location);
      marker = new google.maps.Marker({
        map: map,
        position: results[0].geometry.location,
      });
      lat.value = results[0].geometry.location.lat();
      lng.value = results[0].geometry.location.lng();
    } else {
      alert("該当する結果がありませんでした：" + status);
    }
  });
}

window.initMap = initMap;
window.codeAddress = codeAddress;
