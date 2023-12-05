module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './public/*.html',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
      colors:{
        body: "#fffffc",
        "selected-text": "#faab78",
        theme: "#d7e9b9",
        secondary: "#fffbac",
        badge: "#3f3f51",
        inputBorder: "#565666",
        input: "#2a2a33",
      },
      fontFamily: {
        poppins: ["Poppins", "sans-serif"],
        // sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  }
}
