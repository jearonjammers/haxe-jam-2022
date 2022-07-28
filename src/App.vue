<template>
  <div id="app">
    <component
      class="ui"
      v-if="ui"
      :is="ui.def"
      v-bind="uiprops"
      :style="{ width: gameWidth + 'px' }"
    />
    <canvas ref="canvas" />
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    return {
      gameWidth: 1920,
      gameHeight: 1080,
      stack: [],
    };
  },
  computed: {
    ui() {
      const last = this.stack.length - 1;
      return this.stack[last];
    },
    uiprops() {
      return { ...this.ui.props };
    },
  },
  mounted() {
    window.flambe = {
      canvas: this.$refs.canvas,
    };
    const flambe = require("../build.hxml");
    this.stack = flambe.flambe.System.get_web().stack;
    const sizer = flambe.game.Container.getSize;
    window.addEventListener("resize", this.layoutScale.bind(this, sizer));
    this.layoutScale(sizer);
    flambe.game.Main.start(this.gameWidth, this.gameHeight);
  },
  methods: {
    layoutScale(sizer) {
      var size = sizer(
        this.gameWidth,
        this.gameHeight,
        window.innerWidth,
        window.innerHeight
      );
      document.documentElement.style.setProperty("--layout-scale", size.scale);
      document.documentElement.style.setProperty("--layout-x", size.x + "px");
      document.documentElement.style.setProperty("--layout-y", size.y + "px");
    },
  },
};
</script>

<style lang="scss">
#app,
html,
body {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
}
body {
  background-image: url(/assets/background.png);
  background-color: #EF9CBD;
  background-size: 150px 150px;
}
.ui {
  position: absolute;
  top: var(--layout-y);
  left: var(--layout-x);
  transform: scale(var(--layout-scale));
  transform-origin: 0 0;
}
canvas {
  display: block;
  width: 100%;
  height: 100%;
}
#app {
  width: 100%;
  height: 100%;
}
</style>
