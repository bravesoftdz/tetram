<template>
	<v-card>
		<template v-if="!compact && !noHeader">
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
									:disabled="api_loading"
									hide-details
									ref="quickSearchInput"
							></v-text-field>
						</v-flex>
						<slot name="sub-header"/>
					</v-layout>
				</v-layout>
			</v-card-title>
			<v-divider></v-divider>
		</template>
		<v-progress-linear
				height="3"
				color="secondary"
				indeterminate
				v-if="api_loading && !$itemsLoaded"
				class="progress"
		/>
		<div
				v-for="item in items" :key="item.id"
				@click="item.$expanded = !item.$expanded"
		>
			<template v-if="isGroupedBy">
				<div class="item parentItem">
					<slot name="display-group" v-bind:group="item">
						{{ item }}
					</slot>
				</div>
				<template v-if="item.$expanded">
					<v-progress-linear
							v-if="api_loading && !item.$itemsLoaded"
							indeterminate
							color="secondary"
							class="mx-auto progress"
							height="3"
					/>
					<template v-else>
						<div v-for="subitem in refreshSubItems(item)" :key="subitem.id" class="item subItem">
							<slot name="display-item" v-bind:item="subitem">
								{{ subitem }}
							</slot>
						</div>
					</template>
				</template>
			</template>
			<div v-else class="item">
				<slot name="display-item" v-bind:item="item">
					{{ item }}
				</slot>
			</div>
		</div>

		<v-divider v-if="pagination.pages > 1"/>
		<v-card-actions v-if="pagination.pages > 1">
			<v-pagination
					v-model="pagination.page"
					:length="pagination.pages"
					prev-icon="mdi-menu-left"
					next-icon="mdi-menu-right"
					circle
					:total-visible="paginationVisiblePages"
					class="mx-auto"
			/>
		</v-card-actions>
	</v-card>
</template>

<script>
  import debounce from 'lodash.debounce'
  import { NULL_ID } from '../mixins/global/API'

  export default {
    name: 'ModelTree',
    components: {},
    props: {
      noHeader: {type: Boolean, required: false, default: false},
      title: {type: String, required: false},
      model: {type: String, required: true},
      quickSearchFields: {
        type: Function | String | [String],
        required: false,
        default: () => []
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
      },
      defaultFilter: {type: Function | Array, required: false, default: () => []},
      compact: {type: Boolean, required: false, default: false}
    },
    data: () => ({
      items: [],
      pagination: {pages: 0, page: 1, rowsPerPage: this.perPage, totalItems: 0},
      quickSearchFilter: '',
      itemKey: 'id',
      $itemsLoaded: false
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
      },
    },
    methods: {
      /**
       * @param {string|array|object|function} p
       * @returns {array}
       */
      arrayFromParam (p) {
        let a = []
        switch (typeof p) {
          case 'string':
            a.push(p)
            break
          case 'function':
            a.push(p())
            break
          case 'object':
          case 'array':
            a.push(...p)
            break
        }
        return a
      },
      sortObjectFromParam (p, groupId = null) {
        let r = {}
        switch (typeof p) {
          case 'string':
            r.sortBy = p
            r.sortDirection = 'asc'
            break
          case 'function':
            r = p(groupId)
            break
          case 'object':
            r = p
            break
        }
        return r
      },
      updateItemKey () {
        switch (typeof this.groupKey) {
          case 'function':
            this.itemKey = this.groupKey()
            break
          default:
            this.itemKey = this.groupKey
        }
      },
      /**
       * @param {Number|integer} page
       * @param {Boolean} resetItems
       */
      refreshItems ({page = undefined, resetItems = false} = {}) {
        if (resetItems) {
          this.items = []
          this.pagination = {...this.pagination, ...{pages: 0, page: 1, totalItems: 0}}
        }

        this.$itemsLoaded = false
        this.getItems({
          page: page
        }).then(data => {
          this.items = data.items
          this.pagination = {...this.pagination, ...data.pagination}
        }).finally(() => {
          this.$itemsLoaded = true
        })
      },
      /**
       * @param item
       */
      refreshSubItems (item) {
        if (!item.$items) {
          item.$items = []
          item.$itemsLoaded = false
        }

        if (!item.$itemsLoaded && !this.api_loading) {
          this.getItems({
            groupByColumn: this.itemKey === 'id' ? `${this.groupedBy}.id` : this.groupedBy,
            groupById: item[this.itemKey]
          }).then(data => {
            item.$items = data.items
          }).finally(() => {
            item.$itemsLoaded = true
          })
        }
        return item.$items
      },
      /**
       * @param {Number|integer} page
       * @param {string|null} groupByColumn
       * @param {string|null} groupById
       * @param {Boolean} resetItems
       * @returns {Promise<any>}
       */
      getItems ({page = undefined, groupByColumn = undefined, groupById = undefined}) {
        let filters = []
        if (groupById) {
          filters.push({
            column: groupByColumn,
            value: groupById !== NULL_ID ? groupById : null
          })
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
          })

          if (filters.length === 0) {
            filters.push(...newFilters)
          } else {
            filters.push({c: newFilters})
          }
        }
        let defaultFilters = this.arrayFromParam(this.defaultFilter)
        switch (defaultFilters.length) {
          case 0:
            break
          case 1:
            filters.push(...defaultFilters)
            break
          default:
            filters.push({c: defaultFilters})
        }

        return new Promise(resolve => {
          this.$getItems({
            model: this.model,
            page: page,
            perPage: (this.compact || this.perPage || groupById) ? (this.compact || groupById ? -1 : this.perPage) : undefined,
            filters: filters,
            sortBy: this.sortObjectFromParam(this.sortBy, groupById),
            groupBy: groupById ? null : this.groupedBy,
            groupBySort: this.sortObjectFromParam(this.groupBySort)
          }).then(data => {
            data.items.forEach(item => {
              item.$expanded = false
              if (!groupById) {
                if (!item[this.itemKey]) item[this.itemKey] = NULL_ID
              }
            })
            resolve(data)
          })
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
	.item {
		min-height: 2em !important;
		padding: 0 1em !important;
	}

	.item.subItem {
		padding: 0 1em 0 3em !important;
	}

	.item.parentItem {
		font-weight: bold;
		cursor: pointer;
	}

	.progress {
		margin: 0;
	}
</style>