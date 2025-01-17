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
        class="map-popup"
        ref="markers"
      >
        <l-icon 
          :icon-url="iconUrl"
          :icon-size="iconSize"
          :icon-anchor="iconAnchor"

          :shadow-url="shadowUrl"
          :shadow-size="shadowSize"
          :shadow-anchor="shadowAnchor"
        />
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
import { LMap, LTileLayer, LCircle, LMarker, LIcon, LPopup, LControlZoom} from "@vue-leaflet/vue-leaflet";
import {ref} from 'vue';
import 'leaflet/dist/leaflet.css';
import shadowImage from 'leaflet/dist/images/marker-shadow.png';
import MapPopupListings from '@components/maps/MapPopupListings.vue';

export default {
  setup(){
    const debug_circle = ref(null);

    return {debug_circle};
  },
  created() {
    console.log('debug prop value:', this.debug);
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
    LMap, LTileLayer, LMarker, LIcon, LPopup, LCircle,LControlZoom,
    MapPopupListings
  },
  data() {
    return {
      iconUrl: require('@/assets/images/icons/markers/large_center_blue_marker.svg'),
      iconSize: [38, 95], // Default icon size
      iconAnchor: [19, 67.5], // Default icon anchor

      shadowUrl: shadowImage,
      shadowSize: [50, 64], // Default shadow size
      shadowAnchor: [10, 61] // Default shadow anchor
    };
  },
  methods: {
    
    handleMarkerClick(listingId) {
      this.$refs['ref_' + listingId + '_popup'][0].callApi();
      console.log("Clicked on marker: "+listingId);
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