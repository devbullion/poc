<template>
  <div>
    <GenderSlider v-model="genderValue" />
    <SizeSlider v-model="sizeValue" />
    <PriceSlider v-model="priceValue" />
    <p>
		Gender Value: {{ (genderValue*100).toFixed(0) }}% Male<br>
		Size Value: {{ sizeValue }}㎡<br>
		Price Value: ￥{{ priceValue.toLocaleString() }}
    </p>
    <p>
		<b>API Call:</b> {{ this.apiUrl }}<br>
		<b>API Response:</b> {{ this.apiResponse }}
	</p>
	<div v-if="columns.length > 0">
      <table>
        <thead>
          <tr>
            <th v-for="(col, index) in columns" :key="index">{{ col.label }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(row, index) in rows" :key="index">
            <td v-for="(col, colIndex) in columns" :key="colIndex">{{ row[col.field] }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>


<script>
import GenderSlider from './components/sliders/GenderSlider.vue';
import SizeSlider from './components/sliders/SizeSlider.vue';
import PriceSlider from './components/sliders/PriceSlider.vue';

export default {
  components: {
    GenderSlider,
    PriceSlider,
    SizeSlider
  },
  
  data() {
    return {
      genderValue: 0.5,
      sizeValue: 30,
      priceValue: 5000,
      
      apiUrl: null,
      apiResponse: null,
      
      columns: [],
      rows: []
    };
  },
  
  methods: {
	createApiUrl(){
		return `http://127.0.0.1:5000/listings?lat=34.6826516&lon=135.8154434&dist=5000&m=${this.genderValue}&size=${this.sizeValue}&px=${this.priceValue}&btype=beauty`;
	},
	
	async callApi(){
		this.apiUrl = this.createApiUrl();
		
		try{
			const response = await fetch(this.apiUrl);
			if(! response.ok) throw new Error('Network Response was not ok', response);
			
			const data = await response.json();
			console.log("Received the data from the API", data);
			this.apiResponse = data;
			
			this.rows = data;
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
    priceValue: 'callApi'
  }
};
</script>