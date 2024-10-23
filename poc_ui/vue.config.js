const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  
  // REMOVE In Production
  devServer: {
    proxy: {
      '/listings': {
        target: 'http://127.0.0.1:5000',
        changeOrigin: true,
        pathRewrite: { '^/listings': '' }, // Optional: Adjust if your API has a base path
      },
    },
  },
})
