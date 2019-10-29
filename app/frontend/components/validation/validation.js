/**
 * Create a custom class for JavaScript Validations and Input Adjustments.
 * Mainly used as a namespace.
 * @param {none} none There are no parameters or constructors for this class.
 */
export default class Validation {
  /**
   * Validates the string URL is a legit url for various validations.
   * @param {string} url A string that is a URL from an input field.
   * @return {boolean} True if matches the URL Regex. 
  */
  static validUrl(url){ 
    const regex = RegExp(/^((https?|ftp):\/\/)?([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&%$-]+)*@)*((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}|([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2-4}))(:[0-9]+)*(\/($|[a-zA-Z0-9.,?'\\+&%$#=~_-]+))*$/); 
    return regex.test(url); 
  }
}