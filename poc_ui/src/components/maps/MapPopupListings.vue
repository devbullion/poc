<template>
    <div>

        <!-- Title Area -->
        <div class="popup-title-area block">
            <div class="is-size-4 has-text-left has-text-weight-semibold">{{ this.address }}</div>
            <div class="is-size-7 has-text-left has-text-weight-light">
                {{ this.latlng }}
            </div>
            <div class="is-size-7 has-text-left has-text-weight-normal">
                {{ this.apiResponse.length + " Listing" + (this.apiResponse.length > 1 ? "s" : "") + " at this Address" }}
            </div>
        </div>

        
        
        <!-- List Area -->
        <div class="popup-listings-container">
            <table>
                <!-- Loop over the listings-->
                <div v-for="listing in apiResponse" :key="listing.property_inquiry_number">

                    <!-- Initially visible -->
                    <tr @click="toggleAccordion(listing.property_inquiry_number)">
                        <!-- The Score Icon -->
                        <td>
                            <div class = "donut_container">
                                <div class="donut_inner is-size-5 has-text-weight-semibold">
                                    {{ listing.total_score }}
                                </div>
                                <div class="donut_listing_type has-text-weight-normal">
                                    For Rent
                                </div>
                                <Doughnut :data="getDonutData(listing.total_score)" :options="donutOptions"/>
                            </div>
                        </td>

                        <!-- The Details -->
                        <td>
                            <div class="listing-title is-size-5 has-text-weight-semibold">￥{{listing.price ? listing.price.toLocaleString() : "N/A" }} / {{ listing.sq_m + "㎡"}}</div>
                            <div class="listing-details is-size-7">
                                <b>Built In:</b> {{ listing.built_month }}/{{ listing.built_year }} ({{ listing.built_age }} Yrs Old)
                            </div>
                            <div class="listing-details is-size-7">
                                <b>Dist to Sta:</b> {{ getDisToStaText(listing) }}
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <button class="accordion-button is-size-7 has-text-weight-light" @click.stop="toggleAccordion(listing.property_inquiry_number)">
                                <span :class="['arrow', { active: (this.dropdownIndex != null && this.dropdownIndex===listing.property_inquiry_number) }]">&#9654;</span>
                            </button>
                        </td>
                    </tr>

                    <!-- Hidden Initially -->
                    <tr :class="['accordion-content', { open: (this.dropdownIndex != null && this.dropdownIndex===listing.property_inquiry_number) }]">
                        <td colspan="2">
                            <ListingDetailedView 
                                :debug="debug" 
                                :apiParams="apiParams"
                                :listing="listing"
                                :listingID="listing.property_inquiry_number"

                                :ref="'ref_'+listing.property_inquiry_number+'_listing_detailed_view'"
                            />
                        </td>
                    </tr>
                </div>
            </table>
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

import ListingDetailedView from './ListingDetailedView.vue';
import {createApiUrlForAddress, callRestApi} from '../../utils/rest_api_utils.js';

ChartJS.register(CategoryScale, LinearScale, ArcElement, Tooltip, ChartDataLabels);

export default {
    props: {
        apiParams: { type: Object, required: true },
        address: {type: String, required: true, default: ''},
        latlng: {type: Array, required: true, default: ()=>[]},

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
        async callApi(){
            this.apiUrl = createApiUrlForAddress({...this.apiParams, lat: this.latlng[0], lon: this.latlng[1]});
            this.apiResponse = await callRestApi(this.apiUrl);
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

        getDisToStaText( listing){
            var resultStr = listing.dist_to_sta_walk_time + "Min Walk";

            // If the mode is not just walking
            if( listing.dist_to_sta_other_mode){
                if(listing.dist_to_sta_other_mode == "バス")
                    return listing.dist_to_sta_other_mode_time + " Min Bus + " + resultStr;
            }
            return resultStr;
        }
    }
}
</script>