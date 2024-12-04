<template>
    <!-- Map -->
    <div>
    <!-- Add this here: @moveend="updateCenter" to update-->
    <LMap
        ref="map"
        :zoom="12"
        :center="modelValue"
        style="height: 100%; width: 100%"
    >
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
              :latlng="modelValue" 
              :radius="radius" color="black" 
        />
        
        <!-- Loop over the listings and put markers-->
        <template v-for="listing in listings" :key="'key_'+listing.address">
            <LMarker
                v-if="listing!=null && listing.latitude!=null && listing.longitude!=null"
                :key="'key_'+listing.address+'_Lmarker'"
                :latlng="[listing.latitude, listing.longitude]"
                width="480px" height="1000px"
                @click="handleMarkerClick(listing.address)"
            >
                <!-- We set autoPan to false due to the recursion -->
                <LPopup 
                  ref="popup" 
                  :listing_id= "listing.address"
                  :key="'key_'+listing.address + '_Lpopup'"
                >
                    <MapPopupListings 
                      :apiParams="apiParams"
                      :address="listing.address"
                      :latlng="[listing.latitude, listing.longitude]"
                      :debug="debug" 
                      :ref="'ref_' + listing.address + '_popup'"
                    />
                </LPopup>
            </LMarker>
        </template>
    </LMap>  
    </div>
</template>

<script>
import { LMap, LTileLayer, LMarker, LCircle, LPopup } from 'vue3-leaflet';
import {ref} from 'vue';
import 'leaflet/dist/leaflet.css';

import MapPopupListings from './MapPopupListings.vue';

export default {
  setup(){
    const debug_circle = ref(null);
    return {debug_circle};
  },
  props: {
    apiParams: { type: Object, required: true },
    modelValue: { type: Array, required: true },
    radius: {type: Number, required: true, default: 5000},
    listings: {type: Array, required: true, default: () => []},
    debug: {type: Boolean, required: true, default: false},
  },
  components: {
    LMap, LTileLayer, LMarker, LCircle, LPopup, 
    MapPopupListings
  },
  
  methods: {
    handleMarkerClick(listingId) {
      this.$refs['ref_' + listingId + '_popup'][0].callApi();
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

<style scoped>
  .leaflet-container {
    height: 640px !important;
    width: 640px !important;
  }

.custom-popup {
  width: 300px !important;
  height: 300px !important;
}

.custom-popup-content {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}
</style>