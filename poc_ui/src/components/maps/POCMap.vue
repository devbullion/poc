<template>
  <!-- Map -->
  <!-- Add this here: @moveend="updateCenter" to update-->
  <LMap
    ref="map"
    :zoom="14"
    :options="{zoomControl: false}"
    :center="modelValue"
    style="height: 100%; width: 100%;"
  >
    <!-- Add Zoom Control -->
    <LControlZoom position="bottomright" />
    <!-- The Map Tile -->
    <LTileLayer 
      url='https://tile.openstreetmap.org/{z}/{x}/{y}.png'
      layer-type="base"
      name="OpenStreetMap"
    />

    <!-- The radius (for debug purposes only) -->
    <LCircle 
      ref="debug_circle"
      v-if="debug"
        :lat-lng="modelValue" 
        :radius="radius" color="black" 
    />
    
    <!-- Loop over the markers and put markers on the map -->
    <template v-for="marker in markers" :key="'key_'+marker.address+'_'+this.apiParams['btype']">
      <l-marker
        v-if="marker!=null && marker.latitude!=null && marker.longitude!=null"
        :key="'key_'+marker.address+'_Lmarker'"
        :latlng="[marker.latitude, marker.longitude]"
        :lat-lng="[marker.latitude, marker.longitude]"
        
        @click="handleMarkerClick(marker.address)"
        :icon="extraMarkerIcon"
      >
        <l-icon 
          :icon-url="getMarkerIconUrl(marker.max_score)"
          :icon-size="iconSize"
          :icon-anchor="iconAnchor"

          :shadow-url="shadowUrl"
          :shadow-size="shadowSize"
          :shadow-anchor="shadowAnchor"
        />
        <l-tooltip :options = "tooltipOptions">{{marker.max_score}}</l-tooltip>
        <!-- We set autoPan to false due to the recursion -->
        <LPopup 
          ref="popup" 
          :listing_id= "marker.address"
          :key="'key_'+marker.address + '_Lpopup'"
        >
          <MapPopupListings 
            :apiParams="apiParams"
            :address="marker.address"
            :latlng="[marker.latitude, marker.longitude]"

            :debug="debug" :lang="lang"
            :ref="'ref_' + marker.address + '_popup'"
          />
        </LPopup>
      </l-marker>
    </template>
  </LMap>
</template>

<script>
import { LMap, LTileLayer, LCircle, LMarker, LPopup, LControlZoom, LTooltip, LIcon} from "@vue-leaflet/vue-leaflet";
import {ref} from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import 'leaflet-extra-markers/dist/css/leaflet.extra-markers.min.css';
import 'leaflet-extra-markers/dist/js/leaflet.extra-markers.min.js';

import shadowImage from 'leaflet/dist/images/marker-shadow.png';
import MapPopupListings from '@components/maps/MapPopupListings.vue';

// const top_n = 3;

export default {
  setup(){
    const debug_circle = ref(null);
    return {debug_circle};
  },
  props: {
    apiParams: { type: Object, required: true },
    modelValue: { type: Array, required: true },
    radius: {type: Number, required: true, default: 5000},
    markers: {type: Array, required: true, default: () => []},
    lang: {type: String, default: 'en'},
    debug: {type: Boolean, default: false},
  },
  components: {
    LMap, LTileLayer, LMarker, LPopup, LCircle, LControlZoom, LTooltip, LIcon,
    MapPopupListings
  },
  data() {
    const markerWidth = 38;
    const markerHeight = 95;

    return {
      extraMarkerIcon: L.ExtraMarkers.icon({
        icon: 'fa-number',
        number: '1',
        markerColor: 'blue',
        shape: 'square',
        prefix: 'fa'
      }),
      iconSize: [markerWidth, markerHeight], // Default icon size
      iconAnchor: [markerWidth/2, 67.5], // Default icon anchor

      shadowUrl: shadowImage,
      shadowSize: [50, 64], // Default shadow size
      shadowAnchor: [12, 64], // Default shadow anchor

      tooltipOptions: {
        direction: 'center',
        offset: [0, -26],
        permanent: true
      },
    };
  },
  methods: {
    getMarkerIconUrl(max_score) {

      if(this.markers[0].max_score == max_score)
        return require('@/assets/images/icons/markers/large_center_gold_marker.svg');
      else
        return require('@/assets/images/icons/markers/large_center_blue_marker.svg');
      
    },
    handleMarkerClick(address) {
      if(this.debug) console.log("Clicked on marker: "+address);
      console.log(this.$refs['ref_' + address + '_popup'][0]);
      this.$refs['ref_' + address + '_popup'][0].setPopupOpen(true);
      this.$refs['ref_' + address + '_popup'][0].callApi();
    },

    updateCenter(e) {
      const center = e.target.getCenter();
      const newLatLng = [center.lat, center.lng];
      if(newLatLng != this.modelValue){
        console.log("Center of map updated to", center);
        // Emit the new center coordinates
        this.$emit('update:modelValue', newLatLng);

        // Update the circle as needed
        if(this.debug){
          const oldCircleLatLng = this.debug_circle.getLatLng();
          if(oldCircleLatLng != newLatLng ){
              console.log("Updating Circle center to "+newLatLng);
              this.debug_circle.setLatLng(newLatLng);
          }
        }
      }
    },
  },
};
</script>