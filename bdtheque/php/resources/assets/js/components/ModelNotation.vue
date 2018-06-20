<template>
	<v-layout v-if="value" row class="shrink notation">
		<img :src="getSrc(0)" >
		<img :src="getSrc(1)">
		<img :src="getSrc(2)">
		<img :src="getSrc(3)">
		<img :src="getSrc(4)">
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
        type: String | Function,
        required: false,
        default: require('./../../images/full16.png')
      },
      halfStarImg: {
        type: String | Function,
        required: false,
        default: require('./../../images/half_l16.png')
      },
      emptyStarImg: {
        type: String | Function,
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
	.notation {
		height: 16px;
		display: inline-flex;
		padding-left: 0.5em;
		vertical-align: sub;
	}
</style>