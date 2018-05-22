<template>
	<v-card>
		<v-card-title>
			<div class="headline">{{ $t(this.title)}}</div>
			<v-spacer></v-spacer>
			<v-text-field
					v-model="quickSearchFilter"
					append-icon="search"
					label="Search"
					single-line
					clearable
					:disabled="loading"
					hide-details
					ref="quickSearchInput"
			></v-text-field>
		</v-card-title>
		<v-divider></v-divider>
		<v-progress-linear
				height="3"
				color="secondary"
				indeterminate
				:active="loading"
				class="progress"
		></v-progress-linear>
		<v-data-table
				:items="items"
				:pagination="pagination"
				:total-items="pagination.totalItems"
				hide-actions
				hide-headers
		>
			<template slot="items" slot-scope="{ item }">
				<td>
					<slot name="display-item" v-bind:item="item">
						{{ item }}
					</slot>
				</td>
			</template>
			<v-alert slot="no-results" :value="true" color="error" icon="warning">
				Your search for "{{ quickSearchFilter }}" found no results.
			</v-alert>
		</v-data-table>
		<v-divider v-if="pagination.totalItems > 0"></v-divider>
		<v-card-actions v-if="pagination.totalItems > 0">
			<v-pagination
					v-model="pagination.page"
					:length="pagination.pages"
					prev-icon="mdi-menu-left"
					next-icon="mdi-menu-right"
					circle
					:total-visible="paginationVisiblePages"
					class="mx-auto"
			></v-pagination>
		</v-card-actions>
	</v-card>
</template>

<script>
  import axios from 'axios'
  import debounce from 'lodash.debounce'

  export default {
    name: 'ModelIndex',
    props: {
      title: {type: String, required: false},
      model: {type: String, required: true},
      quickSearchFields: {
        type: Function | String | [String],
        required: false,
        default: []
      },
      sortBy: {
        type: Function | Object,
        required: false
      },
      groupBy: {type: String, required: false},
      groupBySort: {
        type: Function | Object,
        required: false
      },
      perPage: {
        type: Number,
        required: false,
        default: 10
      }

    },
    data: () => ({
      items: [],
      loading: false,
      pagination: {pages: 0, page: 1, rowsPerPage: 10, totalItems: 0},
      firstLoad: true,
      quickSearchFilter: ''
    }),
    mounted () {
      this.delayedRefreshItems = debounce(() => { this.refreshItems() }, 500)
      this.refreshItems()
    },
    watch: {
      'pagination.page' (newValue, oldValue) {
        if (oldValue !== newValue)
          this.refreshItems(newValue)
      },
      quickSearchFilter () {
        this.delayedRefreshItems()
      }
    },
    methods: {
      /**
       * @param {string|array|object|function} p
       * @returns {array}
       */
      arrayFromParam (p) {
        let a = []
        switch (typeof p) {
          case 'string': {
            a.push(p)
            break
          }
          case 'function': {
            a.push(p())
            break
          }
          case 'object':
          case 'array': {
            a.push(...p)
            break
          }
        }
        return a
      },
      sortObjectFromParam (p) {
        let r = {}
        switch (typeof p) {
          case 'string': {
            r.sortBy = p
            r.sortDirection = 'asc'
            break
          }
          case 'function': {
            r = p()
            break
          }
          case 'object':
            r = p
            break
        }
        return r
      },
      /**
       * @param {Number|integer} page
       */
      refreshItems (page = null) {
        this.loading = true

        let filters = []
        if (this.quickSearchFilter && this.quickSearchFilter !== '') {
          let fields = this.arrayFromParam(this.quickSearchFields)

          filters = Array.from(fields, (field) => {
            return {
              operator: 'or',
              column: field,
              comparison: 'like',
              value: `%${this.quickSearchFilter}%`
            }
          })
        }

        let params = []
        if (page) params.push(`page=${page}`)
        if (this.perPage) params.push(`perPage=${this.perPage}`)

        axios.post(
          `/api/${this.model}/index` + (params.length ? '?' + params.join('&') : ''), {
            filters: filters,
            sortBy: this.sortObjectFromParam(this.sortBy),
            groupBy: this.groupBy,
            groupBySort: this.sortObjectFromParam(this.groupBySort),
          })
          .then(response => {
            this.items = response.data.data
            this.pagination.rowsPerPage = response.data.pagination.per_page
            this.pagination.page = response.data.pagination.current_page
            this.pagination.totalItems = response.data.pagination.total
            this.pagination.pages = response.data.pagination.total_pages

            this.loading = false
          })
          .catch(e => {
              this.loading = false
              this.errors.push(e)
            }
          )
      }
    },
    computed: {
      paginationVisiblePages () {
        return this.pages > 10 ? 7 : null
      }
    }
  }
</script>

<style scoped>
	.progress {
		margin: 0;
	}
</style>