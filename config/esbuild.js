const esbuild = require('esbuild')
const postcss = require('postcss')
const tailwindcss = require('tailwindcss')
const fs = require('fs')
const path = require('path')

const entryPoints = [path.join(__dirname, '../app/javascript/application.js')]
const outdir = path.join(__dirname, '../app/assets/builds')

esbuild.build({
  entryPoints: entryPoints,
  outdir: outdir,
  bundle: true,
  sourcemap: true,
  watch: process.argv.includes('--watch'),
  plugins: [
    {
      name: 'tailwindcss',
      setup(build) {
        build.onResolve({ filter: /\.css$/ }, args => {
          return { path: args.path, namespace: 'tailwindcss' }
        })

        build.onLoad({ filter: /.*/, namespace: 'tailwindcss' }, async (args) => {
          const css = await fs.promises.readFile(args.path, 'utf8')
          const result = await postcss([tailwindcss]).process(css, { from: args.path })
          return { contents: result.css, loader: 'css' }
        })
      },
    },
  ],
}).catch(() => process.exit(1))
