document.addEventListener(
  "turbo:load",
  function () {
    let geocoder;
    let map;
    const mapDisplay = document.getElementById("map");
    const mapSearch = document.getElementById("mapSearch");
    if (mapDisplay != null) {
      map = initMap(mapDisplay, map);
      if (mapSearch != null) {
        geocoder = new google.maps.Geocoder();
        mapSearch.addEventListener(
          "click",
          { map: map, geocoder: geocoder, handleEvent: codeAddress },
          false
        );
      }
    }
  },
  false
);

function initMap(mapDisplay, map) {
  if (
    mapDisplay.dataset.latitude == undefined &&
    mapDisplay.dataset.longitude == undefined
  ) {
    map = new google.maps.Map(mapDisplay, {
      center: { lat: 36.204824, lng: 138.252924 },
      zoom: 4,
    });
  } else {
    const lat = parseFloat(mapDisplay.dataset.latitude);
    const lng = parseFloat(mapDisplay.dataset.longitude);
    map = new google.maps.Map(mapDisplay, {
      center: { lat: lat, lng: lng },
      zoom: 12,
    });
    const marker = new google.maps.Marker({
      map: map,
      position: { lat: lat, lng: lng },
    });
  }
  return map;
}

function codeAddress() {
  let map = this.map;
  let geocoder = this.geocoder;
  let lat = document.getElementById("lat");
  let lng = document.getElementById("lng");

  let inputAddress = document.getElementById("address").value;
  geocoder.geocode({ address: inputAddress }, function (results, status) {
    if (status == "OK") {
      map.setCenter(results[0].geometry.location);
      const marker = new google.maps.Marker({
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
