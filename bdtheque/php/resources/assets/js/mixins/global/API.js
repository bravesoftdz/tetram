import axios from 'axios'

export const NULL_ID = '<null>'

export default {
  data: () => ({
    loadingCount: 0
  }),
  watch: {
    loadingCount (newValue) {
      // if (newValue > 0) {
      //   this.$router.app.$loading.start()
      // } else {
      //   this.$router.app.$loading.finish()
      // }
    }
  },
  computed: {
    api_loading () { return this.loadingCount > 0 }
  },
  methods: {
    /**
     * @param {string} model
     * @param {string} itemId
     * @param {Boolean} full
     * @returns {Promise<any>}
     */
    $getItem ({model, itemId, full = true}) {
      this.loadingCount++
      return new Promise((resolve, reject) => {
        axios.get(
          `/api/${model}/${itemId}${full ? '?full' : ''}`
        ).then(response => {
          resolve(response.data.data)
        }).catch(e => {
          this.errors.push(e)
          reject(e)
        }).finally(() => {
          this.loadingCount--
        })
      })
    },

    /**
     * @param {string} model
     * @param {Number|integer} page
     * @param {Number|integer} perPage
     * @param {[SearchSimpleCriteria | SearchMultipleCriterias]} filters
     * @param {SortParam} sortBy
     * @param {string|null} groupBy
     * @param {SortParam} groupBySort
     * @returns {Promise<GetItemsResponse>}
     */
    $getItems ({model, page = undefined, perPage = 15, filters = [], sortBy = undefined, groupBy = undefined, groupBySort = undefined}) {
      this.loadingCount++
      return new Promise((resolve, reject) => {
        let params = []
        if (page) params.push(`page=${page}`)
        if (perPage) params.push(`perPage=${perPage}`)

        axios.post(
          `/api/${model}/index` + (params.length ? '?' + params.join('&') : ''), {
            filters: filters,
            sortBy: sortBy,
            groupBy: groupBy,
            groupBySort: groupBySort
          }
        ).then(response => {
          resolve({
            items: response.data.data,
            pagination: !response.data.pagination ? undefined : {
              rowsPerPage: response.data.pagination.per_page,
              page: response.data.pagination.current_page,
              totalItems: response.data.pagination.total,
              pages: response.data.pagination.total_pages
            }
          })
        }).catch(e => {
          this.errors.push(e)
          reject(e)
        }).finally(() => {
          this.loadingCount--
        })
      })
    }

  }
}
