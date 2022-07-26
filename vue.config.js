// vue.config.js
module.exports = {
  publicPath: "/haxe-jam-2022",
  chainWebpack: (config) => {
    // GraphQL Loader
    config.module
      .rule("haxe")
      .test(/\.hxml$/)
      .use("haxe-loader")
      .loader("haxe-loader")
      .tap(() => {
        return {
          debug: true,
        };
      })
      .end();
  },
};
