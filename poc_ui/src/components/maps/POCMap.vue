<template>
    <!-- Map -->
    <div>
    <p>{{ modelValue }}</p>
    <LMap
        ref="map"
        :zoom="13"
        :center="modelValue"
        style="height: 100%; width: 100%"
        @moveend="updateCenter"
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
            :latlng="modelValue" :radius="radius" color="black" 
        >
        </LCircle>
        
        <!-- Loop over the listings and put markers-->
        <template v-for="listing in listings">
            <LMarker
                v-if="listing!=null && listing.total_score >= 60"
                :key="listing.listing_id"
                :latlng="[listing.lat, listing.lon]"
            >
                <!-- We set autoPan to false due to the recursion -->
                <LPopup ref="popup" :autoPan="false" :listing_id= "listing.listing_id">
                    <MapPopupView :listing="listing" :debug="debug" :ref="'mapPopup_' + listing.listing_id"  />
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

import MapPopupView from './MapPopupView.vue';

export default {

  setup(){
    const debug_circle = ref(null);
    return {debug_circle};
  },
  props: {
    modelValue: { type: Array, required: true },
    radius: {type: Number, required: true, default: 5000},

    listings: {type: Array, required: true, default: () => []},

    debug: {type: Boolean, required: true, default: false},
  },
  components: {
    LMap, LTileLayer, LMarker, LCircle, LPopup, 
    MapPopupView
  },
  mounted() {
    this.$nextTick(() => {
        console.log("mounted",this.$refs.map );
        this.$refs.map.map.on('popupopen', this.onPopupOpen);
    })
  },
  methods: {
    onPopupOpen(e){
        this.$nextTick(()=>{ 
            const listingId = e.popup.options.listing_id;
            const mapPopupRef = this.$refs['mapPopup_'+listingId];
            console.log("Mappopup ref", mapPopupRef);
        })
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
</style>