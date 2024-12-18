# This assumes you have Homebrew installed
brew update
brew install node
brew upgrade node

# node -v
# v22.10.0
# npm -v
# 10.9.0

# Install Vue.js/CLI
npm install -g @vue/cli
npm install vue-router
npm install vuex

# vue --version
# @vue/cli 5.0.8

# Install Bulma
npm install -D sass sass-loader
npm install bulma

npm install flag-icon-css

# For the Maps
npm install vue3-leaflet leaflet
npm install leaflet.gridlayer.googlemutant

# For the Charts
npm install chart.js vue-chartjs
npm install chartjs-plugin-datalabels
npm install countup.js

# Run the app
npm update
npm run build-css
npm run serve

chmod +x poc_ui/deploy_website.sh