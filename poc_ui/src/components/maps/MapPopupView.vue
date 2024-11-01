<template>
    <div class="popup-listing">
        <table class="grid-table">
            <tr>
                <!-- Donut -->
                <td class="donut-col" rowspan=2>
                    <div class="donut-outer">
                        <div class="donut-inner">{{ listing.total_score }}</div>
                        <Doughnut :data="donutData" :options="donutOptions" />
                    </div>
                </td>
                <!-- Address -->
                <td class="info-col">
                    <div class="address">{{ listing.add_pref_name }}{{ listing.add_city_name }}{{ listing.add_street_name }}</div>
                </td>
            </tr>

            <!-- Second line of info -->
            <tr>
                <td class="info-col">
                    <div class = "second-info-line">
                        ￥{{ listing.price.toLocaleString() }} / {{ listing.sq_m }}㎡
                    </div>
                </td>
            </tr>

            <tr>
                <td colspan="2" class="bar-row">
                    <div style="width: 100%; height: 30%;">
                        <Bar :data="barData" :options="barOptions" />
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan=2>
                    <table class="button-table">
                        <tr>
                            <td class="button-cell">Contact Sales</td>
                            <td class="button-cell">Get Report</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</template>

<script>
import {
  Chart as ChartJS,
  ArcElement, BarElement,
  CategoryScale, LinearScale,
  Tooltip
} from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';
import {Doughnut, Bar} from 'vue-chartjs';

ChartJS.register(CategoryScale, LinearScale, BarElement, ArcElement, Tooltip, ChartDataLabels);

export default {
    props: {
        listing: {type: Object, required: true, default: null},
        debug: {type: Boolean, required: true, default: false},
    },

    components: {
        Bar, Doughnut,
    },

    data(){
        const fillColor = 'rgb(255,215,0)';
        const fillerColor = 'rgba(220,220,220,100)';
        const barDataLabels = ['Pop Score', 'Price Score', 'Size Score'];
        const barDataValues = [ (this.listing.pop_score*100).toFixed(0), (this.listing.price_score*100).toFixed(0), (this.listing.size_score*100).toFixed(0) ];

        const barData = {
            labels: barDataLabels,
            datasets: [{ data: barDataValues }]
        };
        const barOptions = {
            animation:{
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
                }
            },
            scales: { 
                x: {
                    beginAtZero: true,
                    grid: {display: false},
                    max: 130,
                    ticks: {display: false},
                }
            },
            skipNull: false,
        };

        const donutData = {
            labels: ['Total Score'],
            datasets: [{data: [this.listing.total_score, 100-this.listing.total_score]}]
        };
        const donutOptions = {
            animation:{
                duration: 2000,
                easing: 'easeInOutQuart',
            },
            backgroundColor: [fillColor, fillerColor],
            plugins : {
                datalabels: {display: false},
                tooltips: {display: false}
            },
            totalScore: this.listing.total_score,
            
        };
        return {barData, barOptions, donutData, donutOptions};
    }
}
</script>

<style>
    .popup-listing{
        width: 300px;
    }
    .popup-listing .grid-table {
        width: 100%;
        border-collapse: collapse;
        padding: 0;
    }

    .popup-listing td {
        border: 1px solid red;
    }

    .address {
        height: 70%;
        font-weight: bold;
        font-size: 15px;
    }
    .second-info-line {
        height: 30%;

        font-weight: normal;
        font-size: 12px;
        vertical-align: top;

        border: 1px solid green;
    }

    /* Fixed width for the first column */
    .donut-col {
        width: 80px;
    }

    /* Second column dynamically takes remaining space */
    .info-col {
        width: 220px;
        text-align: left;
        padding: 10 0 0 0;
    }

    /* Bar chart spans full table width */
    .bar-row {
        width: 100%;
    }

    .button-table{
        width: 100%;
        text-align: center;
        padding: 0;
    }
    .button-cell{
        width: 50%;
        background-color: darkgray;
    }

    /* Donut styling */
    .donut-outer {
        width: 80px;
        height: 80px;
        position: relative;
    }

    .donut-inner {
        width: 100%;
        height: 100%;

        position: absolute;
        top: 0;
        left: 0;
        line-height: 80px;
        text-align: center;
        font-size: 25px;
        font-weight: bold;
    }

</style>