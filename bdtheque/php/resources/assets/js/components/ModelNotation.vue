<template>
	<v-layout row>
		<img :src="getSrc(0)" style="height: 16px">
		<img :src="getSrc(1)" style="height: 16px">
		<img :src="getSrc(2)" style="height: 16px">
		<img :src="getSrc(3)" style="height: 16px">
		<img :src="getSrc(4)" style="height: 16px">
	</v-layout>
</template>

<script>
  export default {
    name: 'ModelNotation',
    props: {
      value: {
        type: Number | undefined,
        required: true,
        validator: (value) => !value || [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].includes(value)
      },
      fullStarImg: {
        Type: String | Function,
        required: false,
        default: require('./../../images/full16.png')
      },
      halfStarImg: {
        Type: String | Function,
        required: false,
        default: require('./../../images/half_l16.png')
      },
      emptyStarImg: {
        Type: String | Function,
        required: false,
        default: require('./../../images/empty16.png')
      }
    },
    methods: {
      /**
       * @param {Number} imgIndex
       * @returns {String}
       */
      getSrc (imgIndex) {
        if (!this.value)
          return ''
        if (this.value > 1 + (imgIndex * 2))
          return this.getPath(this.fullStarImg)
        if (this.value <= imgIndex * 2)
          return this.getPath(this.emptyStarImg)
        return this.getPath(this.halfStarImg)
      },
      /**
       * @param {String|Function} img
       * @returns {String}
       */
      getPath (img) {
        switch (typeof img) {
          case 'string':
            return img
          case 'function':
            return img()
          default:
            return ''
        }
      }
    }
  }
</script>

<style scoped>

</style>