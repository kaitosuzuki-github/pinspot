document.addEventListener("DOMContentLoaded", googleMap, false);
document.addEventListener("turbo:render", googleMap, false);

let map;
let marker = [];

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
      const infoWindow = new google.maps.InfoWindow({ maxWidth: 400 });
      JSON.parse(posts).forEach(function (post, index) {
        marker[index] = new google.maps.Marker({
          map: map,
          position: { lat: post.latitude, lng: post.longitude },
          title: post.title,
        });
        const contentString =
          `<div class="space-y-2">` +
          `<h2 class="text-lg font-bold text-gray-900">${post.title}</h2>` +
          `<p class="text-gray-900 text-sm"><span class="font-semibold">撮影スポット: </span>${post.location}</p>` +
          `<a href="/posts/${post.id}" class="inline-block rounded px-3 py-1.5 bg-green-500 hover:bg-gradient-to-r hover:from-green-500 hover:to-green-400 text-white transition-all ease-out duration-300">投稿を見る</a>` +
          `</div>`;
        marker[index].addListener("click", () => {
          infoWindow.close();
          infoWindow.setContent(contentString);
          infoWindow.open(marker[index].getMap(), marker[index]);
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
