<template>
  <div>

    <!-- Radio Buttons -->
    <div>
      <label><input type="radio" value="beauty" v-model="businessType" />Beauty Salon</label>
      <label><input type="radio" value="gym" v-model="businessType" />Gym</label>
    </div>

    <!-- Sliders -->
    <GenderSlider v-model="genderValue" />
    <SizeSlider v-model="sizeValue" />
    <PriceSlider v-model="priceValue" />

    <!-- Status -->
    <p v-if = "debug" >
      Gender Value: {{ (genderValue*100).toFixed(0) }}% Male<br>
      Size Value: {{ sizeValue }}㎡<br>
      Price Value: ￥{{ priceValue.toLocaleString() }}<br>
      Lat, Lng: {{ mapLatLng }}<br>
      Radius: {{mapRadius}}m
    </p>

    <!-- Map -->
    <div>
      <POCMap v-model="mapLatLng" :radius="mapRadius" :listings="apiResponse" :debug="debug" />
    </div>

    <!-- API Call -->
    <p v-if="debug">
      <b>API Call:</b> {{ this.apiUrl }}<br>
      <b>API Response:</b> {{ this.apiResponse }}
    </p> 

    <!-- Table of the API Response -->
    <div v-if="columns.length > 0 && debug">
      <table>
        <thead>
          <tr><th v-for="(col, index) in columns" :key="index">{{ col.label }}</th></tr>
        </thead>

        <tbody>
          <tr v-for="(row, index) in apiResponse" :key="index">
            <td v-for="(col, colIndex) in columns" :key="colIndex">{{ row[col.field] }}</td>
          </tr>
        </tbody>
      </table>
    </div>

  </div>
</template>


<script>
import POCMap from "./components/maps/POCMap.vue"

import GenderSlider from './components/sliders/GenderSlider.vue';
import SizeSlider from './components/sliders/SizeSlider.vue';
import PriceSlider from './components/sliders/PriceSlider.vue';

export default {
  components: {
    POCMap,

    GenderSlider,
    PriceSlider,
    SizeSlider
  },
  
  data() {
    return {
      debug: true, // Change this to false	
      mapLatLng: [34.6826516, 135.8154434], 
      mapRadius: 5000,

      businessType: "beauty",
      
      genderValue: 0.5,
      sizeValue: 30,
      priceValue: 5000,
      
      apiUrl: null,
      apiResponse: [],
      
      columns: [],
      rows: []
    };
  },
  
  methods: {
  /** Simple method to create the API string */  
	createApiUrl(){
		return `http://127.0.0.1:5000/listings?lat=${this.mapLatLng[0]}&lon=${this.mapLatLng[1]}&dist=${this.mapRadius}&m=${this.genderValue}&size=${this.sizeValue}&px=${this.priceValue}&btype=${this.businessType}`;
	},
	
	async callApi(){
		this.apiUrl = this.createApiUrl();
		
		try{
      console.log("Fetching from API: "+ this.apiUrl);

			const response = await fetch(this.apiUrl);
			if(! response.ok) throw new Error('Network Response was not ok', response);
			const data = await response.json();

			console.log("Received the data from the API", data);
			this.apiResponse = data;
			
			if(data.length > 0){
				this. columns = Object.keys(data[0]).map(key => ({
					label: key,
					field: key
				}));
			}
		} catch(error) {
			console.error('Error fetching from the API: ', error);
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