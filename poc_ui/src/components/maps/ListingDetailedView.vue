<template>
    <div class = "listing_detailed_view">
        <Bar 
            width="100%"
            :data="barData" 
            :options="barOptions" 
            :ref="'barChart'"
        />
         <div v-if="debug"> 
            <b>BarData</b> {{ barData }}<br>
        </div> 
        {{ barData }}
    </div>
</template>

<script>
import {
  Chart as ChartJS, BarElement,
  CategoryScale, LinearScale,
  Tooltip
} from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';
import {Bar} from 'vue-chartjs';
import {createApiUrlForListingDetail, callRestApi} from '../../utils/rest_api_utils.js';
import { getLangText } from '../../utils/lang_utils';

ChartJS.register(CategoryScale, LinearScale, BarElement, Tooltip, ChartDataLabels);

export default {
    props: {
        apiParams: { type: Object, required: true },
        listing: {type: Object, required: true, default: null},
        listingID: {type: String, required: true, default: null},
        lang: {type: String, required: true},
        debug: {type: Boolean, required: true, default: false},
    },
    components: {
        Bar,
    },
    computed:{
        barData() {
            var data =[];
            if(this.apiResponse==null || this.apiResponse.length==0){
                data= [0,0,0];
            } else {
                data = [ 
                    Math.round(this.apiResponse[0].pop_score*100), 
                    Math.round(this.apiResponse[0].price_score*100), 
                    Math.round(this.apiResponse[0].size_score*100),
                ]
            }

            return{
                labels: [
                    getLangText(this.lang, {
                        "en": 'Pop Score',
                        "ja": '人口スコア'
                    }), 
                    getLangText(this.lang, {
                        "en": 'Price Score',
                        "ja": '価格スコア'
                    }), 
                    getLangText(this.lang, {
                        "en": 'Size Score',
                        "ja": 'サイズスコア'
                    }), 
                ],
                datasets: [{ data: data }]
            }
        }
    },
    data(){
        const fillColor = 'rgb(255,215,0)';
        const barOptions = {
            animation:{
                delay: 350,
                duration: 2000,
                easing: 'easeInOutQuart',
            },
            backgroundColor: [fillColor,fillColor,fillColor],
            indexAxis: 'y',
            plugins: {
                datalabels: {
                    anchor: 'end',
                    align: 'right',
                    color: 'black',
                    font:{size: 10},
                }
            },
            scales: { 
                x: {
                    beginAtZero: true,
                    display: false,
                    grid: {
                        display: false,
                        drawBorder: false,
                    },
                    max: 125,
                    // ticks: {display: false},
                },
                y: {
                    grid: {display: false},
                    ticks: {
                        font: {size: 10},
                    },
                }
            },
            skipNull: false,
        };
        const apiUrl = null;
        const apiResponse = [];
        return {apiUrl, apiResponse, barOptions};
    },
    methods:{
        async callApi(){
            this.apiUrl = createApiUrlForListingDetail({...this.apiParams, id: this.listingID});
            this.apiResponse = await callRestApi(this.apiUrl);
        },
    }
}
</script>

<style>
    .listing_detailed_view {
        width: 100%;
        height: 100px;

    }

    Bar{
        width: 100%;
        height: 100%;
    }
</style>