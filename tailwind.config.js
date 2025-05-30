/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./node_modules/flowbite/**/*.js"
  ],
  safelist: [
    "hidden",
    "flex",
    "flex-col",
    "fixed",
    "top-[76px]",
    "left-1/2",
    "-translate-x-1/2",
    "transform",
    "z-50",
    "bg-red-100",
    "text-red-800",
    "bg-green-100",
    "text-green-800",
    "bg-blue-100",
    "bg-gray-100",
    "bg-yellow-400",
    "bg-yellow-800",
    "text-gray-400",
    "text-gray-600",
    "text-gray-800",
    "shadow-md",
    "rounded-lg",
    "px-4",
    "py-2",
    "text-white",
    "text-base",
    "font-medium",
    "max-w-md",
    "mx-auto",

    // Grade color classes (ensure Tailwind keeps these)
    "bg-emerald-500",
    "bg-sky-500",
    "bg-amber-500",
    "bg-orange-500",
    "bg-rose-500",
    "bg-red-600",
    "bg-gray-300",
    "bg-white",
    "border",
    "border-gray-400"
  ],
  theme: {
    extend: {
      screens: {
        widescreen: { raw: "(min-aspect-ratio: 3/2)" },
        tallscreen: { raw: "(min-aspect-ratio: 13/20)" }
      },
      keyframes: {
        "open-menu": {
          "0%": { transform: "scaleY(0)" },
          "80%": { transform: "scaleY(1.2)" },
          "100%": { transform: "scaleY(1)" }
        }
      },
      animation: {
        "open-menu": "open-menu 0.5s ease-in-out forwards"
      }
    }
  },
  plugins: []
}
