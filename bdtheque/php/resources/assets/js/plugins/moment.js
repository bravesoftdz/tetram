import Vue from 'vue'

const {locale} = window.config

const moment = require('moment')
moment.locale(locale)

/**
 * @param carbonDate
 * @returns {String|null}
 */
Vue.prototype.$Carbon2Moment = function (carbonDate) {
  // only case 3 + UTC is really sure...

  switch (carbonDate.timezone_type) {
    case 1:
      // A UTC offset, such as in new DateTime("17 July 2013 -0300");
      return moment.parseZone(carbonDate.date)
    case 2:
      // A timezone abbreviation, such as in new DateTime("17 July 2013 GMT");
      return moment.parseZone(carbonDate.date)
    case 3:
      // A timezone identifier, such as in new DateTime( "17 July 2013", new DateTimeZone("Europe/London"));
      return carbonDate.timezone === 'UTC' ? moment.utc(carbonDate.date) : null
  }
  return null
}

Vue.use(require('vue-moment'), {
  moment
})
