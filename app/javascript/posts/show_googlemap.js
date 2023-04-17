const latLng = document.getElementById("map");
const lat = parseFloat(latLng.dataset.latitude);
const lng = parseFloat(latLng.dataset.longitude);

function initMap() {
  const map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: lat, lng: lng },
    zoom: 12,
  });

  const marker = new google.maps.Marker({
    map: map,
    position: { lat: lat, lng: lng },
  });
}

window.initMap = initMap;
