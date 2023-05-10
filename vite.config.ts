import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import svgr from 'vite-plugin-svgr'
import FullReload from 'vite-plugin-full-reload'

const path = require('path')

export default defineConfig({
  plugins: [
    RubyPlugin(),
    svgr(),
    FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 200 })
  ],
  root: path.resolve(__dirname, 'src'),
  resolve: {
    alias: {
      '~bootstrap': path.resolve(__dirname, 'node_modules/bootstrap'),
    }
  },
})
