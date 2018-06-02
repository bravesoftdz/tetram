<template>
	<v-card>
		<v-card-title>
			<v-layout row>
				<div class="headline">{{ this.title }}</div>
				<v-spacer></v-spacer>
				<v-layout column>
					<v-flex>
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
					</v-flex>
					<slot name="sub-header"/>
				</v-layout>
			</v-layout>
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
				:no-data-text="loading ? 'Chargement...' : 'Pas de données à afficher'"
				:item-key="itemKey"
		>
			<template slot="items" slot-scope="args">
				<tr v-if="isGroupedBy" @click="args.expanded = !args.expanded" style="cursor: pointer">
					<td :style="itemStyle" style="font-weight: bold">
						<slot name="display-group" v-bind:group="args.item">
							{{ args.item }}
						</slot>
					</td>
				</tr>
				<tr v-else>
					<td :style="itemStyle">
						<slot name="display-item" v-bind:item="args.item">
							{{ args.item }}
						</slot>
					</td>
				</tr>
			</template>
			<template slot="expand" slot-scope="{ item }">
				<v-card flat>
					<v-data-table
							:items="refreshSubItems(item)"
							hide-actions
							hide-headers
					>
						<tr slot="items" slot-scope="{ item }">
							<td :style="subItemStyle">
								<slot name="display-item" v-bind:item="item">
									{{ item }}
								</slot>
							</td>
						</tr>
						<template slot="no-data">
							<v-progress-circular indeterminate color="secondary" class="mx-auto"></v-progress-circular>
						</template>
					</v-data-table>
				</v-card>
			</template>
			<v-alert slot="no-results" :value="true" color="error" icon="warning">
				Pas de résultat correspondant à la recherche "{{ quickSearchFilter }}".
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
  import { NULL_ID } from '../bdtheque/GlobaleFunctions'

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
      groupBy: {type: Function | String, required: false, default: ''},
      groupBySort: {
        type: Function | Object,
        required: false
      },
      perPage: {
        type: Number,
        required: false,
        default: 15
      },
      groupKey: {
        type: Function | String,
        required: false,
        default: 'id'
      }
    },
    data: () => ({
      items: [],
      loading: false,
      pagination: {pages: 0, page: 1, rowsPerPage: this.perPage, totalItems: 0},
      quickSearchFilter: '',
      itemStyle: 'height: 3em !important; padding: 0 2em !important;',
      subItemStyle: 'height: 3em !important; padding: 0 4em !important;',
      itemKey: 'id'
    }),
    mounted () {
      this.updateItemKey()
      this.delayedRefreshItems = debounce(() => { this.refreshItems() }, 500)
      this.refreshItems()
    },
    watch: {
      'pagination.page' (newValue, oldValue) {
        if (oldValue !== newValue)
          this.refreshItems({page: newValue})
      },
      quickSearchFilter () {
        this.delayedRefreshItems()
      },
      groupBy () {
        this.updateItemKey()
        this.refreshItems({resetItems: true})
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
      sortObjectFromParam (p, groupId = null) {
        let r = {}
        switch (typeof p) {
          case 'string': {
            r.sortBy = p
            r.sortDirection = 'asc'
            break
          }
          case 'function': {
            r = p(groupId)
            break
          }
          case 'object':
            r = p
            break
        }
        return r
      },
      updateItemKey () {
        switch (typeof this.groupKey) {
          case 'function': {
            this.itemKey = this.groupKey()
            break
          }
          default:
            this.itemKey = this.groupKey
        }
      },
      /**
       * @param {Number|integer} page
       * @param {Boolean} resetItems
       */
      refreshItems ({page = null, resetItems = false} = {}) {
        this.getItems({page: page, resetItems}).then(data => {
            this.items = data.items
            this.pagination = {...this.pagination, ...data.pagination}
          }
        )
      },
      /**
       * @param item
       */
      refreshSubItems (item) {
        if (!item.items) {
          item.items = []
          item.itemsLoaded = false
        }

        if (!item.itemsLoaded && !this.loading) {
          this.getItems({
              groupByColumn: this.itemKey === 'id' ? `${this.groupedBy}.id` : this.groupedBy,
              groupById: item[this.itemKey]
            }
          ).then(data => {
              item.items = data.items
            }
          ).finally(() => {
              item.itemsLoaded = true
            }
          )
        }
        return item.items
      },
      /**
       * @param {Number|integer} page
       * @param {string|null} groupByColumn
       * @param {string|null} groupById
       * @param {Boolean} resetItems
       * @returns {Promise<any>}
       */
      getItems ({page = undefined, groupByColumn = undefined, groupById = undefined, resetItems = false} = {}) {
        this.loading = true
        if (resetItems) {
          this.items = []
          this.pagination = {...this.pagination, ...{pages: 0, page: 1, totalItems: 0}}
        }
        return new Promise((resolve, reject) => {
          let filters = []
          if (groupById) {
            filters.push({
                column: groupByColumn,
                value: groupById !== NULL_ID ? groupById : null
              }
            )
          }
          if (this.quickSearchFilter && this.quickSearchFilter !== '') {
            let fields = this.arrayFromParam(this.quickSearchFields)

            let newFilters = Array.from(fields, (field) => {
                return {
                  operator: 'or',
                  column: field,
                  comparison: 'like',
                  value: `%${this.quickSearchFilter}%`
                }
              }
            )

            if (filters.length === 0)
              filters.push(...newFilters)
            else
              filters.push({c: newFilters})
          }

          let params = []
          if (page) params.push(`page=${page}`)
          if (this.perPage || groupById) params.push(`perPage=${groupById ? -1 : this.perPage}`)

          axios.post(
            `/api/${this.model}/index` + (params.length ? '?' + params.join('&') : ''), {
              filters: filters,
              sortBy: this.sortObjectFromParam(this.sortBy, groupById),
              groupBy: groupById ? null : this.groupedBy,
              groupBySort: this.sortObjectFromParam(this.groupBySort),
            }
          ).then(response => {
              if (!groupById) {
                response.data.data = Array.from(response.data.data, (item) => {
                    if (!item[this.itemKey])
                      item[this.itemKey] = NULL_ID
                    return item
                  }
                )
              }

              resolve({
                  items: response.data.data,
                  pagination: !response.data.pagination ? undefined : {
                    rowsPerPage: response.data.pagination.per_page,
                    page: response.data.pagination.current_page,
                    totalItems: response.data.pagination.total,
                    pages: response.data.pagination.total_pages,
                  }
                }
              )
            }
          ).catch(e => {
              this.errors.push(e)
            }
          ).finally(() => {
              this.loading = false
            }
          )
        })
      }
    },
    computed: {
      paginationVisiblePages () { return (this.pagination && this.pagination.pages > 10) ? 7 : null},
      groupedBy () {
        let groupBy = (typeof this.groupBy) === 'function' ? this.groupBy() : this.groupBy
        return !groupBy ? undefined : groupBy
      },
      isGroupedBy () { return this.groupedBy && (this.groupedBy !== '') }
    }
  }
</script>

<style scoped>
	.progress {
		margin: 0;
	}
</style>