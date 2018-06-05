export default {
  methods: {
    /**
     * @param {String} $routeName
     * @param {BaseModel} $item
     * @returns {{name: *, params: {id: *}}}
     * @constructor
     */
    ItemRoute: ($routeName, $item) => ({name: $routeName, params: {itemId: $item.id}})
  }
}
