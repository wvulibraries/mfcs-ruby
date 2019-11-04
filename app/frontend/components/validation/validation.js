/**
 * Create a custom class for JavaScript Validations and Input Adjustments.
 * Mainly used as a namespace.
 * @param {none} none There are no parameters or constructors for this class.
 */
export default class Validation {
  /**
   * validUrl
   * Validates the string URL is a legit url for various validations.
   * @param {string} url A string that is a URL from an input field.
   * @return {boolean} True if matches the URL Regex. 
  */
  static validUrl(url){ 
    const regex = RegExp(/^((http(s)?:\/\/(www\.)?)|(ftp:\/\/(www\.)?)|(www\.))([A-Za-z0-9]{1,61})\.([\-a-zA-Z0-9\(\)\@\:\%\_\+\.\~\#\?\&\/\=]{0,1500})/); 
    return regex.test(url); 
  }

  /**
   * sanitizeInput
   * Removes dangerous html from a string.
   * @param {string} input A string of input typically from an input field such the help field in the form builder.
   * @return {string} returns the modified string from the regex replace.
  */
  static sanitizeInput(input){ 
    let regex = /<\/?(script|embed|object|frameset|frame|iframe|meta|link|style).*?>/gmi;
    return input.replace(regex, "");
  }

  /**
   * checkForSpaces
   * Tests string for spaces.
   * @param {string} input String input testing.
   * @return {boolean} returns true if there are spaces.
  */
  static checkForSpaces(input){ 
    return /\s/gi.test(input);
  }

  /**
   * isEmtpy
   * Tests that the item is not empty, will most likely be a string.
   * Does not test values of objects or keys of objects. 
   * @param {object} input should be a string, but it may not be.
   * @return {boolean} returns true if string is empty or not a string.
  */
  static isEmpty(input){
    if (input == null) return true; 
    if (typeof input == 'undefined') return true; 
    if (typeof input == 'string') { 
      let str = input.replace(/\s/gi, '');
      return str.length === 0;
    }
    if (typeof input == 'object' && !Array.isArray(input)) { 
      return Object.keys(input).length === 0 && input.constructor === Object
    }
    return (0 === input.length); 
  }

  /**
   * stripHTML
   * Remove HTML from the input string.
   * @param {string} input from input field.
   * @return {string} modified string
  */
  static stripHTML(input){ 
    return input.replace(/<[^>]*>?/gm, '');
  }
}