module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {
      screens: {
        widescreen: { raw: "(min-aspect-ratio: 3/2)" },
        tallscreen: { raw: "(min-aspect-ratio: 1/2)" }
      }
    }
  },
  plugins: [
    require("flowbite/plugin")({
      charts: true
    })
  ],
  content: ["./node_modules/flowbite/**/*.js"]
}
