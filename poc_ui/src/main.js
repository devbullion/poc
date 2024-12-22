import { createApp } from 'vue'
import App from './App.vue'

// Styles
import 'leaflet/dist/leaflet.css';
import './assets/styles/scss/styles.scss'; 

import VTooltip from 'v-tooltip'

const app = createApp(App);
app.use(VTooltip);
app.mount('#app')