<template>

</template>

<script>

  export default {
    name: 'ModelCard',
    props: {
      itemId: {type: String}
    },
    data: () => ({
      item: {},
      model: '',
    }),
    mounted () {
      this.reloadItem()
    },
    watch: {
      $route () { this.reloadItem() }
    },
    methods: {
      reloadItem () {
        this.$getItem({
          model: this.model,
          itemId: this.itemId
        }).then(item => {
          this.item = item
        })
      }
    }
  }
</script>

<style scoped>

</style>