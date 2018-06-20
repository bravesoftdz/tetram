export interface Pagination {
  rowsPerPage: Number,
  page: Number,
  totalItems: Number,
  pages: Number
}

export interface SortParam {
  sortBy: String
  sortDirection: String
}

export interface SearchSimpleCriteria {
  operator: String, // 'or' / 'and'
  column: String,
  comparison: String, // '=' if not set
  value: any, // comparison != 'between'
  value1: any, // comparison = 'between'
  value2: any  // comparison = 'between'
}

export interface SearchMultipleCriterias {
  operator: String, // 'or' / 'and'
  c: [SearchSimpleCriteria | SearchMultipleCriterias],
}

export interface GetItemsResponse<T = any> {
  items: [T],
  pagination: Pagination
}