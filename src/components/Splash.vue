<template>
  <div class="splash" :style="{ width: width + 'px', height: height + 'px' }">
    <img @click="onClick" src="assets/bootstrap/play.png" alt="Start Game" />
  </div>
</template>

<script>
export default {
  props: {
    width: {
      type: Number,
      required: true,
    },
    height: {
      type: Number,
      required: true,
    },
  },
};
</script>

<style scoped lang="scss">
.splash {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-size: 100px 100px;
  background-color: #acdde5;
  img {
    transform: scale(1);
    transition: transform 0.125s ease-in-out;
  }
  img:hover {
    transform: scale(1.05);
    transition: none;
  }
  img:active {
    transform: scale(0.98);
    transition: none;
  }
}
</style>
