<template>
  <p class="hello" @click="onClick">Game clicked {{ name }} times!</p>
</template>

<script>
export default {
  props: {
    name: {
      type: String,
      required: true,
    },
  },
};
</script>

<style scoped lang="scss">
p {
  margin: 0;
  cursor: pointer;
  user-select: none;
  color: #000;
  font-weight: 700;
  font-size: 30px;
  border: 2px solid #000;
  box-sizing: border-box;
  background-color: fuchsia;
}
</style>
