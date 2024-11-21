<template>
    <div class = "listing_detailed_view">
        <Bar 
            width="100%"
            :data="barData" 
            :options="barOptions" 
        />
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

ChartJS.register(CategoryScale, LinearScale, BarElement, Tooltip, ChartDataLabels);

export default {
    props: {
        listing: {type: Object, required: true, default: null},
        debug: {type: Boolean, required: true, default: false},
    },
    components: {
        Bar,
    },
    data(){
        const fillColor = 'rgb(255,215,0)';
        const barDataLabels = ['Pop Score', 'Price Score', 'Size Score'];
        const barDataValues = [ (this.listing.pop_score*100).toFixed(0), (this.listing.price_score*100).toFixed(0), (this.listing.size_score*100).toFixed(0) ];

        const barData = {
            labels: barDataLabels,
            datasets: [{ data: barDataValues }]
        };
        const barOptions = {
            animation:{
                delay: 150,
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
                    max: 140,
                    ticks: {display: false},
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
        return {barData, barOptions};
    }
}
</script>

<style>
    .listing_detailed_view {
        width: 200px;
        height: 100px;

        border: 1px solid green
    }
</style>