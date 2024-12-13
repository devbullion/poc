<template>
  
  <div class="layout-box box">
    <!-- Header -->
    <div class="header-container">
      <div>
        <div class="title is-size-6">DeBullion</div>
      </div>

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
    <div class="columns is-mobile layout-container">
      <!-- Sidebar column -->
      <div class="column is-one-quarter sidebar-container">
        <div class="block">
          <label class = "sidebar-title-container title is-5">
            {{ getLangText(
              this.lang, 
              {
                "en": "What kind of business do you want to open?",
                "ja": "どんなビジネスをしますか？"
              }) 
            }}
          </label>
        </div>

        <!-- Radio Buttons -->
        <div class="radios">
          <label class="radio is-size-6 has-text-weight-medium">
            <div class="is-size-7 radio-text">
              {{ getLangText(this.lang,{"en":"Beauty Salon","ja":"美容室"}) }}
            </div>
            <input type="radio" value="beauty" v-model="businessType" checked/>
            <div class="radio-img-container">
              <img 
                src="./assets/images/icons/icon_beauty_black.png" 
                alt="beauty salon"
              >
            </div>
          </label>
          
          <label class="radio is-size-6 has-text-weight-medium">
            <div class="is-size-7 radio-text">
              {{ getLangText(this.lang,{"en":"Gym","ja":"ジム"}) }}
            </div>
            <input type="radio" value="gym" v-model="businessType" />
            <div class="radio-img-container">
              <img 
                src="./assets/images/icons/icon_gym_black.png" 
                alt="gym"
              >
          </div>
          </label>

          <label class="radio is-size-6 has-text-weight-medium">
            <div class="is-size-7 radio-text disabled-text">
              {{ getLangText(this.lang,{"en":"Bar","ja":"居酒屋・バー"}) }}
            </div>
            <input type="radio" value="bar" v-model="businessType" alt="bar" disabled />
            <div class="radio-img-container">
              <span class="radio-img-text-overlay">Coming Soon</span>
              <img 
                src="./assets/images/icons/icon_bar_black.png"
                alt="bar"
              >
            </div>
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
        <div class ="field">
          <SizeSlider 
            v-model="sizeValue" 
            :lang="lang" :debug="debug"
            />
        </div>
        <div class ="field"><PriceSlider v-model="priceValue" :lang="lang" :debug="debug" /></div>

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
          :lang="lang"
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
      lang: "ja",
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