import { createApp } from 'vue'
import App from './App.vue'

// Styles
import 'leaflet/dist/leaflet.css';
import './assets/styles/scss/styles.scss'; 


const app = createApp(App);
app.mount('#app')