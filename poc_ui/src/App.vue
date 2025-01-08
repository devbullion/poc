<template>
  
  <!--div class="layout-box box"-->
    <!-- Header -->
    <div class="header-container">
      <img src="./assets/images/icons/dbc/logo_horizontal_black.png" alt="DeBullion Logo" class="logo">
      
      <!-- Dropdown -->
      <div class="dropdown">
        <button class="dropbtn is-size-7">
          {{ getLangText(this.lang,
            {
              "en": "English (US)",
              "ja": "日本語"
            }) +" ▼"
          }}
        </button>
        <div class="dropdown-content">
          <a href="#" class="is-size-7" @click="lang = 'en'">
            <span class="flag-icon flag-icon-us"></span> English (US)
          </a>
          <a href="#" class="is-size-7" @click="lang = 'ja'">
            <span class="flag-icon flag-icon-jp"></span> 日本語
          </a>
        </div>
      </div>
    </div>
    
    <!-- The columns-->
    <div class="columns layout-container">
      <!-- Sidebar column -->
      <div class="column is-12-mobile is-4-desktop is-mobile">
        <SidebarComponent v-model:modelValue="sidebarData" :lang="lang" :debug="debug"/>
      </div>

      <!-- Map column -->
      <div class="column is-12-mobile is-8-tablet is-mobile">
        <div class="map-container">
          <POCMap 
            v-model="mapLatLng" 
            :radius="mapRadius" 
            :listings="apiResponse" 
            :apiParams="apiParams" 
            :lang="lang"
            :debug="debug" 
          /> 
      </div>
      </div>

    </div>
  <!--/div-->

  <!-- API Call -->    
  <p v-if="debug">
    {{ this.sidebarData }}<br>
    <b>API Call:</b> {{ this.apiUrl }}<br>
    <b>API Response:</b> {{ this.apiResponse }}
  </p> 
</template>


<script>
import { callRestApi, createApiUrlForListings } from './utils/rest_api_utils';
import { getLangText } from './utils/lang_utils';
import POCMap from "./components/maps/POCMap.vue";
import SidebarComponent from './components/sidebar/SidebarComponent.vue';

export default {
  components: {
    POCMap, SidebarComponent,
  },
  
  data() {
    const mapLatLng = [34.6826516, 135.8154434];
    const mapRadius = 10000;

    return {
      debug: false, // Change this to false	
      lang: "ja",
      mapLatLng: mapLatLng, 
      mapRadius: mapRadius,

      sidebarData: {
        businessType: "beauty",
        genderValue: 0.5,
        sizeValue: 30,
        priceValue: 5000,
      },

      apiUrl: null,
      apiResponse: [],
      apiParams: {},

      radioButtons: [
        {value: "beauty", label: { en: 'Beauty Salon', ja: '美容室' }, disabled: false},
        {value: "gym", label: { en: 'Gym', ja: 'ジム' }, disabled: false},
        {value: "conbini", label: { en: 'Conbini', ja: 'コンビニ' }, disabled: true},
        {value: "clinic", label: { en: 'Clinic', ja: 'クリニック' }, disabled: true},
        
        {value: "restaurant", label: { en: 'Restaurant', ja: '飲食' }, disabled: true},
        {value: "cafe", label: { en: 'Cafe', ja: 'カフェ' }, disabled: true},
        {value: "bar", label: { en: 'Bar', ja: 'バー' }, disabled: true},
        {value: "clothing", label: { en: 'Clothing Store', ja: '洋服' }, disabled: true},
        
        {value: "juku", label: { en: 'Cram School', ja: '学習塾' }, disabled: true},
        {value: "parking", label: { en: 'Parking', ja: '駐車場' }, disabled: true},
        {value: "gas_station", label: { en: 'Gas Station', ja: 'ガソスタ' }, disabled: true},
        {value: "cleaning", label: { en: 'Dry Cleaning', ja: 'クリーニング' }, disabled: true},
        
        {value: "laundromat", label: { en: 'Laundromat', ja: 'コインランドリー' }, disabled: true},
        {value: "hotel", label: { en: 'Hotel', ja: 'ホテル' }, disabled: true},
      ]
    };
  },
  
  methods: {
    getLangText,
    getImageSrc(imagePath) {
      try {
        return require("@/assets/images/"+imagePath);
      } catch (error) {
        return ''; // Return an empty string or a fallback image path
      }
    },
    async callApi(){
      this.updateApiParams();
      this.apiUrl = createApiUrlForListings({...this.apiParams, lat: this.mapLatLng[0], lon: this.mapLatLng[1]});
      this.apiResponse = await callRestApi(this.apiUrl);
    },

    updateApiParams(){
      //console.log("Updating API Params", this.sidebarData);
      this.apiParams ={
        dist: this.mapRadius,
        m: this.sidebarData.genderValue,
        size: this.sidebarData.sizeValue,
        px: this.sidebarData.priceValue,
        btype: this.sidebarData.businessType
      }
    }
  },
  
  mounted() {
    this.callApi(); // Call the API when the component is mounted
  },
  
  watch: {
    sidebarData: { 
      handler:'callApi',
      deep: true
    },

    mapLatLng: 'callApi'
  }
};
</script>