<template>
  <div class="box">
    <div class="columns is-mobile layout-container">
      <!-- Sidebar column -->
      <div class="column is-one-quarter sidebar-container">

        <!-- Radio Buttons -->
        <div class="radios">
          <label class="radio is-size-6 has-text-weight-medium">
            <div class="is-size-7 radio-text">
              {{ getLangText(this.lang,{"en":"Beauty Salon","ja":"美容室"}) }}
            </div>
            <input type="radio" value="beauty" v-model="businessType" checked/>
            <img 
              src="./assets/images/icons/icon_beauty_black.png" 
              alt="beauty salon"
            >
          </label>
          
          <label class="radio is-size-6 has-text-weight-medium">
            <div class="is-size-7 radio-text">
              {{ getLangText(this.lang,{"en":"Gym","ja":"ジム"}) }}
            </div>
            <input type="radio" value="gym" v-model="businessType" />
            <img 
              src="./assets/images/icons/icon_gym_black.png" 
              alt="gym"
            >
          </label>

          <label class="radio is-size-6 has-text-weight-medium">
            <div class="is-size-7 radio-text">
              {{ getLangText(this.lang,{"en":"Bar","ja":"バー"}) }}
            </div>
            <input type="radio" value="bar" v-model="businessType" alt="bar" disabled />
            <img 
              src="./assets/images/icons/icon_bar_black.png"
              alt="bar"
            >
          </label>
        </div>

        <!-- Sliders -->
        <div class ="field">
          <GenderSlider 
            v-model="genderValue" 
            :lang="lang"
            :debug="debug"
          />
        </div>
        <div class ="field"><SizeSlider v-model="sizeValue" /></div>
        <div class ="field"><PriceSlider v-model="priceValue" /></div>

        <!-- Status -->
        <p v-if = "debug" >
          Gender Value: {{ (genderValue*100).toFixed(0) }}% Male<br>
          Size Value: {{ sizeValue }}㎡<br>
          Price Value: ￥{{ priceValue.toLocaleString() }}<br>
          Lat, Lng: {{ mapLatLng }}<br>
          Radius: {{mapRadius}}m
        </p>
      </div>

      <!-- Map column -->
      <div class="column map-container">
        <POCMap 
          v-model="mapLatLng" 
          :radius="mapRadius" 
          :listings="apiResponse" 
          :apiParams="apiParams" 
          :debug="debug" 
        /> 
      </div>

    </div>
  </div>
  <!-- API Call -->    
  <p v-if="debug">
    <b>API Call:</b> {{ this.apiUrl }}<br>
    <b>API Response:</b> {{ this.apiResponse }}
  </p> 
</template>


<script>
import { callRestApi, createApiUrlForListings } from './utils/rest_api_utils';
import { getLangText } from './utils/lang_utils';
import POCMap from "./components/maps/POCMap.vue";
import GenderSlider from './components/sliders/GenderSlider.vue';
import SizeSlider from './components/sliders/SizeSlider.vue';
import PriceSlider from './components/sliders/PriceSlider.vue';

export default {
  components: {
    POCMap,
    GenderSlider, PriceSlider, SizeSlider
  },
  
  data() {
    const mapLatLng = [34.6826516, 135.8154434];
    const mapRadius = 10000;

    return {
      debug: false, // Change this to false	
      lang: "en",
      mapLatLng: mapLatLng, 
      mapRadius: mapRadius,

      businessType: "beauty",
      genderValue: 0.5,
      sizeValue: 30,
      priceValue: 5000,

      apiUrl: null,
      apiResponse: [],
      apiParams: {},
    };
  },
  
  methods: {
    getLangText,
    async callApi(){
      this.updateApiParams();
      this.apiUrl = createApiUrlForListings({...this.apiParams, lat: this.mapLatLng[0], lon: this.mapLatLng[1]});
      this.apiResponse = await callRestApi(this.apiUrl);
    },

    updateApiParams(){
      this.apiParams ={
        dist: this.mapRadius,
        m: this.genderValue,
        size: this.sizeValue,
        px: this.priceValue,
        btype: this.businessType
      }
    }
  },
  
  mounted() {
    this.callApi(); // Call the API when the component is mounted
  },
  
  watch: {
    genderValue: 'callApi',
    sizeValue: 'callApi',
    priceValue: 'callApi',
    businessType: 'callApi',

    mapLatLng: 'callApi'
  }
};
</script>