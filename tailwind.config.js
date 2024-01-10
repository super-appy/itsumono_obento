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
        body: "#f2f7f5", // 背景
        "card-body": "#fffffe", // レシピなどの背景
        "card-line": "#597371", // レシピの枠
        theme: "#00473e", // メインの文字色
        secondary: "#475d5b", //小さい文字などの色
        point: "#faae2c", //綺麗な黄色
        inputBorder: "#565666",
        input: "#2a2a33",
      },
      fontFamily: {
        'noto-sans-jp': ['Noto Sans JP', 'sans-serif'],
        // sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  }
}
