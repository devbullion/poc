<template>
    <div>
        <!-- Title Area -->
        <div class = "address">{{ this.address }}</div>
        <div class = "address_details">{{ this.latlng }}</div>
        <div class = "address_details">
            {{ this.listings.length }} 
            Listing {{this.listings.length > 1 ? 
                "s  (Max Score: "+this.listings[0].total_score +"/100)" : 
                ""
            }}
        </div>
        <br>

        <!-- List Area -->
        <div class="table_container">
            <table>
                <!-- Loop over the listings-->
                <div v-for="listing in listings" :key="listing.property_inquiry_number">
                    <!-- Initially visible -->
                    <tr @click="toggleAccordion(listing.property_inquiry_number)">
                        <!-- The Score Icon -->
                        <td>
                            <div class = "donut_container">
                                <div class="donut_inner">{{ listing.total_score }}</div>
                                <div class="donut_listing_type">For Rent</div>
                                <Doughnut :data="getDonutData(listing.total_score)" :options="donutOptions"/>
                            </div>
                        </td>

                        <!-- The Details -->
                        <td>
                            <div class="listing_detail_line_1">￥{{listing.price ? listing.price.toLocaleString() : "N/A" }} / {{ listing.sq_m + "㎡"}}</div>
                            <div class="listing_detail_line_2">
                                <b>Built In:</b> {{ listing.built_month }}/{{ listing.built_year }} ({{ listing.built_age }} Yrs Old)
                            </div>
                            <div class="listing_detail_line_2">
                                <b>Dist to Sta:</b> {{ getDisToStaText(listing) }}
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <button class="accordion-button" @click.stop="toggleAccordion(listing.property_inquiry_number)">
                                <span :class="['arrow', { active: (this.dropdownIndex != null && this.dropdownIndex===listing.property_inquiry_number) }]">&#9654;</span>
                            </button>
                        </td>
                    </tr>

                    <!-- Hidden Initially -->
                    <tr :class="['accordion-content', { open: (this.dropdownIndex != null && this.dropdownIndex===listing.property_inquiry_number) }]">
                        <td colspan="2">
                            <ListingDetailedView 
                                :debug="debug" 
                                :listing="listing"
                            />
                        </td>
                    </tr>
                </div>
            </table>
        </div>
    </div>
</template>

<script>
import {CountUp} from 'countup.js';
import {
  Chart as ChartJS,
  ArcElement,
  CategoryScale, LinearScale,
  Tooltip
} from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';
import {Doughnut} from 'vue-chartjs';

import ListingDetailedView from './ListingDetailedView.vue';

ChartJS.register(CategoryScale, LinearScale, ArcElement, Tooltip, ChartDataLabels);

export default {
    props: {
        address: {type: String, required: true, default: ''},
        debug: {type: Boolean, required: true, default: false},
        latlng: {type: Array, required: true, default: ()=>[]},
        listings: {type: Array, required: true, default: ()=>[]},
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
            plugins : {
                datalabels: {display: false},
                tooltips: {display: false}
            }
            
        };
        return { donutOptions, dropdownIndex};
    },
    methods:{

        toggleAccordion(index) {
            this.dropdownIndex = this.dropdownIndex === index ? null : index;
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
        },
        animatePrice( price, element){
            const countUp = new CountUp(element, price, {
                prefix: '￥',
                duration: 2,
                separator: ',',
            });
            if (!countUp.error) {
                countUp.start();
            } else {
                console.error(countUp.error);
            }
        }
    }
}
</script>

<style scoped>
    table {
        width: 100%;
        border-collapse: collapse;
    }
    tr{
        width: 100%;
    }
    td{
        padding: 0;
    } 

    .address {
        font-size: 16px;
        font-weight: bold;
        /* width: 300px; */
    }
    .address_details {
        font-size: 10px;
        font-weight: light;
    }
    .table_container {
        width: 100%;
        max-height: 180px;
        overflow: auto;
    }

    .donut_container {
        position: relative;
        width: 50px;
        height: 50px;
        /* border: 1px solid red; */
        padding: 0;
    }

    .donut_inner {
        width: 100%;
        height: 100%;

        position: absolute;
        top: 0;
        left: 0;
        line-height: 50px;
        text-align: center;
        font-size: 18px;
        font-weight: bold;
    }

    .donut_listing_type {
        font-size: 6px;
        color: white;
        font-weight: bold;
        text-align: left;
        background-color: red;
        border-radius: 2px;

        position: absolute;
        top: 5%; 
        left: 0;
    }

    .listing_detail_line_1 {
        font-size: 14px;
        font-weight: bold;
    }

    .listing_detail_line_2 {
        font-size: 10px;
        font-weight: normal;
        padding-left: 10px;
    }

    .accordion {
        margin: 20px;
        font-family: Arial, sans-serif;
    }

    .accordion-button {
        display: flex;
        align-items: center;
        justify-content: space-between;
        border: none;
        padding: 0 0 0 10px;
        cursor: pointer;
        font-size: 16px;
        outline: none;
        width: 100%;
    }

    .accordion-button .arrow {
        display: inline-block;
        transition: transform 0.3s ease;
        font-size: 10px;
    }
    .accordion-button .arrow.active {
        transform: rotate(90deg);
    }

    .accordion-content {
        display: none;
        max-height: 0;
        overflow: hidden;
        transition: max-height 0.3s ease, padding 0.3s ease;
        padding: 0;
    }

    .accordion-content.open {
        display: block;
        max-height: 100%;
        overflow: auto;
        transition: max-height 0.3s ease, padding 0.3s ease;
        padding: 0;
    }
</style>