import { Controller } from "@hotwired/stimulus";

let map;
let marker;

export default class extends Controller {
  static targets = ["map", "location", "latitude", "longitude"];

  connect() {
    const lat = this.mapTarget.dataset.latitude;
    const lng = this.mapTarget.dataset.longitude;

    if (lat == undefined && lng == undefined) {
      this.initMap();
    } else {
      this.initMapPost(lat, lng);
    }
  }

  initMap() {
    map = new google.maps.Map(this.mapTarget, {
      center: { lat: 36.204824, lng: 138.252924 },
      zoom: 4,
    });

    const posts = this.mapTarget.dataset.posts;

    if (posts != undefined) {
      this.setMarkers(posts);
    }
  }

  initMapPost(lat, lng) {
    const floatLat = parseFloat(lat);
    const floatLng = parseFloat(lng);

    map = new google.maps.Map(this.mapTarget, {
      center: { lat: floatLat, lng: floatLng },
      zoom: 12,
    });

    marker = new google.maps.Marker({
      map: map,
      position: { lat: floatLat, lng: floatLng },
    });
  }

  setMarkers(posts) {
    const infoWindow = new google.maps.InfoWindow();

    JSON.parse(posts).forEach(function (post, index) {
      let markers = [];

      markers[index] = new google.maps.Marker({
        map: map,
        position: { lat: post.latitude, lng: post.longitude },
        title: post.title,
      });

      const contentString =
        `<div class="p-1 space-y-2">` +
        `<h3>${post.title}</h3>` +
        `<p><span class="font-semibold">撮影スポット: </span>${post.location}</p>` +
        `<a href="/posts/${post.id}" class="post-detail-button">投稿を見る</a>` +
        `</div>`;

      markers[index].addListener("click", () => {
        infoWindow.close();
        infoWindow.setContent(contentString);
        infoWindow.open(markers[index].getMap(), markers[index]);
      });
    });
  }

  codeAddress() {
    let geocoder = new google.maps.Geocoder();
    const inputAddress = this.locationTarget.value;
    let lat = this.latitudeTarget;
    let lng = this.longitudeTarget;

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
}
