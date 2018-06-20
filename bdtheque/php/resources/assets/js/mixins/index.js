import Vue from 'vue'

import API from './global/API'
import DisplayItem from './global/DisplayItem'
import ItemRouter from './global/ItemRouter'
import Debug from './global/Debug'

Vue.mixin(API)
Vue.mixin(DisplayItem)
Vue.mixin(ItemRouter)
Vue.mixin(Debug)
