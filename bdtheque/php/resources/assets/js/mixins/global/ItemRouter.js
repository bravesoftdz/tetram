export default {
  methods: {
    /**
     * @param {String} routeName
     * @param {BaseModel} model
     * @returns {{name: *, params: {id: *}}}
     * @constructor
     */
    $itemRoute (routeName, model) {
      return {
        name: routeName,
        params: {
          itemId: model.id
        }
      }
    }
  }
}
