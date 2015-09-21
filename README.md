# MyApp - Webpack in Phoenix for sane front end development

Original guide for Phoenix 0.12 here: http://manukall.de/2015/05/01/automatically-building-your-phoenix-assets-with-webpack/

The default tool provided in Phoenix (brunch) is pretty annoying to work with and the npm module integration is a pain. (e.g. `import React from 'react'` does not do what you expect, `import 'react/lib/update'` will just totally break on its path finding system, it uses a `vendor` directory by default instead of pulling down packages from npm, etc.)

Because I already use Webpack for many things and it's very good software that lets me truly pull down and use npm modules for my projects, I opted to generate my project with the no brunch flag (`--no-brunch`).

There are a few things to be aware of:

1. You need to provide your own `package.json` (run `npm init` after you generate)
2. You need to install `webpack` and a loader for ES6/JSX (like babel), so you'll need to run `npm i -S webpack` and such.
3. You need to provide webpack configuration (see: [webpack.config.js](./webpack.config.js))
4. Your entry and output should probably match the convention:
```js
[...]
  entry: './web/static/js/app.js',
  output: {
    path: './priv/static/js',
    filename: 'app.js'
  },
[...]
```
5. You need to hook up watchers to your dev task, like so:
```exs
watchers: [{Path.expand("node_modules/webpack/bin/webpack.js"), ["-wd"]}]
```
6. Then run `iex -S mix phoenix.server` as usual and have fun!

## Phoenix details:

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
