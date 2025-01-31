<template>
    <div class = "listing_detailed_view">
        <div class="listing-bar-container">
            <Bar 
                width="100%"
                :data="barData" 
                :options="barOptions" 
                :ref="'barChart'"
            />
        </div>
        <!-- Buttons -->
        <div class="button-container">
            <button class="btn contact-sales" @click="contactSales">
                {{ getLangText(this.lang, 
                    {
                        'en': 'Contact Sales',
                        'ja': '営業部に連絡'
                    }
                )}}
            </button>

            <button class="btn issue-report" @click="requestReport">
                {{ getLangText(this.lang, 
                    {
                        'en': 'Request Report',
                        'ja': 'レポート発行'
                    }
                )}}
            </button>
        </div>
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
import {createApiUrlForListingDetail, callRestApi} from '@utils/rest_api_utils.js';
import { getLangText } from '@utils/lang_utils';

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
            try{
                if(this.apiResponse==null || !this.apiResponse || this.apiResponse.length==0){
                    data= [0,0,0];
                } else {
                    data = [ 
                        Math.round(this.apiResponse[0].pop_score*100), 
                        Math.round(this.apiResponse[0].size_score*100),
                        Math.round(this.apiResponse[0].price_score*100), 
                    ]
                }
            } catch(e){
                console.error(e);
                data= [0,0,0];
            }

            return{
                labels: [
                    getLangText(this.lang, {
                        "en": 'Pop Score',
                        "ja": '人口スコア'
                    }), 
                    getLangText(this.lang, {
                        "en": 'Size Score',
                        "ja": 'サイズスコア'
                    }),
                    getLangText(this.lang, {
                        "en": 'Price Score',
                        "ja": '価格スコア'
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
            backgroundColor: [fillColor, fillColor, fillColor],
            indexAxis: 'y',
            plugins: {
                datalabels: {
                    anchor: 'end',
                    align: 'right',
                    color: 'black',
                    font:{size: 10},
                }
            },
            maintainAspectRatio: false,
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
        const isOpen=false;

        return {apiUrl, apiResponse, barOptions, isOpen};
    },
    watch: {
        apiParams: { 
            handler:'callApi',
            deep: true
        },
    },
    methods:{
        getLangText,
        async callApi(){
            if(this.isOpen){
                if(this.debug) console.log("Calling API from ListingDetailedView.vue "+this.listingID);
            
                this.apiUrl = createApiUrlForListingDetail({...this.apiParams, id: this.listingID});
                this.apiResponse = await callRestApi(this.apiUrl);
            }
        },

        contactSales(){
            const email = 'sales@debullion.io';
            const subject = getLangText(
                this.lang, 
                {
                    'en': 'Inquiry for Listing '+this.listingID, 
                    'ja': '物件'+this.listingID+'についてのお問い合わせ'
                }
            );
            const body = getLangText(
                this.lang,
                {
                    'en': 'Hello DeBullion Sales Team,\n\nI am interested in the listing with ID: '+this.listingID,
                    'ja': '株式会社デブリオン　営業部\n\n物件ID: '+this.listingID+'について興味があります。'
                }
            );
            
            window.location.href = `mailto:${email}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
        },
        requestReport(){
            const email = 'sales@debullion.io';
            const subject = getLangText(
                this.lang, 
                {
                    'en': 'Request Report for '+this.listingID, 
                    'ja': '物件'+this.listingID+'のレポートを発行'
                }
            );
            const body = getLangText(
                this.lang,
                {
                    'en': 'Hello DeBullion Sales Team,\n\nPlease provide me with a PDF report for: '+this.listingID,
                    'ja': '株式会社デブリオン　営業部\n\n物件ID: '+this.listingID+'のPDFレポートをお願いします。'
                }
            );
            
            window.location.href = `mailto:${email}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
        },

        setPopupOpen(isOpen){
            this.isOpen = isOpen;
        }
    }
}
</script>