document.addEventListener("DOMContentLoaded", googleMap, false);
document.addEventListener("turbo:render", googleMap, false);

let map;
let marker;

function googleMap() {
  const mapDisplay = document.getElementById("map");
  const mapSearch = document.getElementById("mapSearch");
  if (mapDisplay != null) {
    initMap(mapDisplay);
    if (mapSearch != null) {
      mapSearch.addEventListener("click", codeAddress, false);
    }
  }
}

function initMap(mapDisplay) {
  const lat = mapDisplay.dataset.latitude;
  const lng = mapDisplay.dataset.longitude;
  if (lat == undefined && lng == undefined) {
    map = new google.maps.Map(mapDisplay, {
      center: { lat: 36.204824, lng: 138.252924 },
      zoom: 4,
    });
    const posts = mapDisplay.dataset.posts;
    if (posts == undefined) {
      marker = null;
    } else {
      JSON.parse(posts).forEach(function (post) {
        marker = new google.maps.Marker({
          map: map,
          position: { lat: post.latitude, lng: post.longitude },
        });
      });
    }
  } else {
    const floatLat = parseFloat(lat);
    const floatLng = parseFloat(lng);
    map = new google.maps.Map(mapDisplay, {
      center: { lat: floatLat, lng: floatLng },
      zoom: 12,
    });
    marker = new google.maps.Marker({
      map: map,
      position: { lat: floatLat, lng: floatLng },
    });
  }
}

function codeAddress() {
  let geocoder = new google.maps.Geocoder();
  let lat = document.getElementById("lat");
  let lng = document.getElementById("lng");
  const inputAddress = document.getElementById("address").value;
  geocoder.geocode({ address: inputAddress }, function (results, status) {
    if (status == "OK") {
      const location = results[0].geometry.location;
      map.setCenter(location);
      if (marker != null) {
        marker.setMap(null);
      }
      marker = null;
      marker = new google.maps.Marker({
        map: map,
        position: location,
      });
      lat.value = location.lat();
      lng.value = location.lng();
    } else {
      alert("該当する結果がありませんでした：" + status);
    }
  });
}
