var LeafletMap = {
  mapId: 'map-canvas',
  tileURL: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  initialZoom: 8
};

LeafletMap.options = {
  minZoom: 0,
  maxZoom: 18,
  attribution: 'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors',
  errorTileUrl: '/images/place-250x250.png'
};

LeafletMap.geoJSONStyle = {
  style: {
    color: '#6AC898',
    fillColor: '#BBF6D7',
    fillOpacity: 0.5
  }
};

LeafletMap.addGeoJSONLayer = function(map, geoJSONFeature) {
  var geoJSONLayer = L.geoJSON(geoJSONFeature, this.geoJSONStyle).addTo(map);
  map.fitBounds(geoJSONLayer.getBounds());
};

LeafletMap.showMap = function(center, geoJSONFeature) {
  var map = new L.map(this.mapId).setView(center, this.initialZoom);
  L.tileLayer(this.tileURL, this.options).addTo(map);
  this.addGeoJSONLayer(map, geoJSONFeature);
};
