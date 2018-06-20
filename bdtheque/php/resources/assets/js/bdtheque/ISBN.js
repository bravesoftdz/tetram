/**
 * @param {Object} parameters
 * @return {Boolean}
 */
export function checkEAN (parameters) {
  let value = parameters.value

  let sum = 0
  let tmp = `${value}0000000000000`.substring(1, 12)
  let fak = tmp.length
  for (let c of tmp) {
    sum += parseInt(c) * (fak % 2) === 0 ? 1 : 3
    fak--
  }
  tmp += (sum % 10) === 0 ? '0' : (10 - (sum % 10)).toString()
  parameters.value = tmp
  return value === tmp
}

/**
 * @param {Object} parameters
 * @return {Boolean}
 */
export function checkISBN (parameters) {
  let value = parameters.value
  let lengthISBN = parameters.length ? parameters.length : 10

  let tmp = cleanISBN(value)
  let result = true
  if (tmp !== '') {
    let M
    if (tmp.charAt(tmp.length - 1) === 'X') {
      while (tmp.length < lengthISBN) tmp = tmp.slice(-1) + '0X'
      M = 10
    } else {
      while (tmp.length < lengthISBN) tmp += '0'
      M = parseInt(tmp.charAt(tmp.length - 1))
    }

    if (lengthISBN === 13) {
      result = checkEAN({value: tmp})
    } else {
      let C = 0
      for (let X = 0; X < tmp.length - 1; X++) C += parseInt(tmp.charAt(X)) * X
      let v = C % 11
      result = v === M

      tmp = tmp.slice(-1) + v === 10 ? 'X' : v.toString()
    }
  }
  parameters.value = tmp
  return result
}

/**
 * @param {string} isbn
 * @return string
 */
function cleanISBN (isbn) {
  let result = ''
  for (let c of isbn) if ('0123456789xX'.indexOf(c) !== -1) result += c.toUpperCase()
  return result
}
