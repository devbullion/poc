<template>
    <div class="popup-container">
        <!-- Title Area -->
        <div class="popup-title-area block">
            <div class="popup-title-area-background"></div>
            <div class="is-size-4 has-text-left has-text-weight-semibold popup-title">{{ this.address }}</div>
            <div class="is-size-7 has-text-left has-text-weight-light popup-title">
                {{ this.latlng }}
            </div>
            <div class="is-size-7 has-text-left has-text-weight-normal popup-title">
                {{ 
                    getLangText(this.lang,
                        {
                            "en": this.apiResponse.length + " Listing" + (this.apiResponse.length > 1 ? "s" : "") + " at this Address" ,
                            "ja": this.apiResponse.length+"物件"
                        }
                    )
                }}
            </div>
        </div>

        <!-- List Area -->
        <div class="popup-listings-container">
            <table>
                <!-- Loop over the listings-->
                <div v-for="listing in apiResponse" :key="listing.property_inquiry_number">

                    <!-- Initially visible -->
                    <tr>
                        <!-- The Score Icon -->
                        <td class="score-td">
                            <div class = "donut_container">
                                <div class="donut_inner is-size-5 has-text-weight-semibold">
                                    {{ listing.total_score }}
                                </div>
                                <div class="donut_listing_type has-text-weight-semibold">
                                    {{getLangText(this.lang, {"en": "For Rent","ja": "賃貸"})}}
                                </div>
                                <Doughnut :data="getDonutData(listing.total_score)" :options="donutOptions"/>
                            </div>
                        </td>

                        <!-- The Details -->
                        <td class="details-td">
                            <div class="details-container">
                                <div>
                                    <div class="listing-title is-size-5 has-text-weight-semibold">￥{{listing.price ? listing.price.toLocaleString() : "N/A" }} / {{ listing.sq_m + "㎡"}}</div>
                                    <div class="listing-details is-size-7">
                                        <b>{{ getLangText(this.lang, {"en": "Built In","ja": "築年月 (築年)"})}}:</b>

                                        {{getLangText(
                                            this.lang, 
                                            {
                                                "en":listing.built_month +"/"+ listing.built_year +" ("+listing.built_age+" Yrs Old)",
                                                "ja": listing.built_year + "年" + listing.built_month + "月 (築"+listing.built_age+"年)"
                                            }
                                        )}}
                                    </div>
                                    <div class="listing-details is-size-7">
                                        <b>{{ getLangText(this.lang, {"en":"Dist to Sta","ja":"交通"})+":"}}</b>
                                        <div v-html="getDisToStaText(listing)"></div>
                                    </div>
                                    <!-- The accordion button -->
                                    <button class="listing-details accordion-button is-size-7 has-text-weight-light" @click.stop="toggleAccordion(listing.property_inquiry_number)">
                                        <span :class="['arrow', { active: (this.dropdownIndex != null && this.dropdownIndex===listing.property_inquiry_number) }]">&#9654;</span>
                                    </button>
                                </div>
                                <button class="btn listing-details-btn" @click.stop="toggleAccordion(listing.property_inquiry_number)">
                                    {{ 
                                        this.dropdownIndex != null && this.dropdownIndex===listing.property_inquiry_number ?
                                        getLangText(this.lang, {"en": "Hide","ja": "閉じる" }) :
                                        getLangText(this.lang, {"en": "Details","ja": "詳細"})
                                    }}
                                </button>
                            </div>
                        </td>
                    </tr>

                    <!-- Hidden Initially -->
                    <tr :class="['accordion-content', { open: (this.dropdownIndex != null && this.dropdownIndex===listing.property_inquiry_number) }]">
                        <td colspan="2">
                            <ListingDetailedView 
                                :debug="debug" :lang="lang"
                                :apiParams="apiParams"
                                :listing="listing"
                                :listingID="listing.property_inquiry_number"

                                :ref="'ref_'+listing.property_inquiry_number+'_listing_detailed_view'"
                            />
                        </td>
                    </tr>
                </div>
            </table>
            <div v-if="debug">
                API URL: {{ apiUrl }}<br>
                API Response: <pre>{{ JSON.stringify(apiResponse, null, 2) }}</pre>
            </div>
        </div>
    </div>
</template>

<script>
import {
  Chart as ChartJS,
  ArcElement,
  CategoryScale, LinearScale,
  Tooltip
} from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';
import {Doughnut} from 'vue-chartjs';

import ListingDetailedView from '@components/maps/ListingDetailedView.vue';
import {createApiUrlForAddress, callRestApi} from '@utils/rest_api_utils.js';
import { getLangText } from '@utils/lang_utils';

ChartJS.register(CategoryScale, LinearScale, ArcElement, Tooltip, ChartDataLabels);

export default {
    props: {
        apiParams: { type: Object, required: true },
        address: {type: String, required: true, default: ''},
        latlng: {type: Array, required: true, default: ()=>[]},

        lang: {type: String, required: true, default: 'en'},
        debug: {type: Boolean, required: true, default: false},
    },
    components: {
        Doughnut, 
        ListingDetailedView
    },
    data(){
        const dropdownIndex = null;
        const fillColor = 'rgb(255,215,0)';
        const fillerColor = 'rgba(220,220,220,100)';
        
        const donutOptions = {
            animation:{
                duration: 2000,
                easing: 'easeInOutQuart',
            },
            backgroundColor: [fillColor, fillerColor],
            borderWidth: 0, 
            borderColor: 'transparent',
            plugins : {
                datalabels: {display: false},
                tooltips: {display: false}
            },
        };
        const apiUrl = null;
        const apiResponse = [];
        return { 
            apiUrl,apiResponse,
            donutOptions, dropdownIndex};
    },
    methods:{
        getLangText,
        async callApi(){
            console.log("Calling API for address: ", this.address, {...this.apiParams, lat: this.latlng[0], lon: this.latlng[1]});
            this.apiUrl = createApiUrlForAddress({...this.apiParams, lat: this.latlng[0], lon: this.latlng[1]});
            console.log("API URL: ", this.apiUrl);
            this.apiResponse = await callRestApi(this.apiUrl);
            console.log("API Response: ", this.apiResponse);
        },


        // UI Methods below this line
        toggleAccordion(index) {
            this.dropdownIndex = this.dropdownIndex === index ? null : index;
            if(this.dropdownIndex != null)
                this.$refs['ref_'+this.dropdownIndex+'_listing_detailed_view'][0].callApi();
        },
        getDonutData( totalScore){
            return {
                labels: ['Total Score'],
                datasets: [{data: [totalScore, 100-totalScore]}]
            };
        },

        getDisToStaText(listing){
            var resultStr = getLangText(this.lang, {
                "en": listing.dist_to_sta_walk_time + "Min Walk",
                "ja": "・"+listing.transportation.replace(/\\n/g,"<br>・")
            });

            // If the mode is not just walking
            if( listing.dist_to_sta_other_mode){
                if(listing.dist_to_sta_other_mode == "バス")
                    resultStr = getLangText(this.lang,{
                        "en": listing.dist_to_sta_other_mode_time + " Min Bus + " + resultStr,
                        "ja": resultStr
                    });
            }
            return resultStr;
        }
    }
}
</script>