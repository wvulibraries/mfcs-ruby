import Validation from "validation/validation";

/**
 * validUrl
 * ============================================================================
*/
describe("#validUrl", ()=> { 
  const valid_test_urls = [ 
    'http://behavior.example.org/',
    'https://www.example.org/berry?back=boundary',
    'https://www.example.net/',
    'http://www.example.com/',
    'http://afterthought.example.com/border/bubble.php',
    'https://example.org/afternoon.aspx',
    'http://bike.example.com/afternoon?act=books',
    'http://example.com/bomb/blade.html',
    'http://www.example.com/',
    'https://bead.example.edu/baseball?angle=back&bell=board',
    'http://www.example.net/anger.php',
    'ftp://www.example.org/', 
    'www.google.com', 
    'www.google.com/berry?black=true', 
    'https://www.google.co',
    'https://www.com',
    'http://www.com', 
    'https://www.google.co.uk'
  ]
  
  const invalid_test_urls = [ 
    'https://<script>console.log("true")</script>.com',
    'google.com', 
    'https://', 
    'www.com',
    'monkeyPatch',
    'http://.org'
  ]  
  // Invalid
  for(let i = 0; i < invalid_test_urls.length; i++) {
    it(`Invalid Test: ${invalid_test_urls[i]}`, () => {   
      expect(Validation.validUrl(invalid_test_urls[i])).toEqual(false); 
    });
  }
  // Valid
  for(let i = 0; i < valid_test_urls.length; i++) {
    it(`Valid Test: ${valid_test_urls[i]}`, () => {   
      expect(Validation.validUrl(valid_test_urls[i])).toEqual(true); 
    });
  }
});

/**
 * sanitizeInput
 * ============================================================================
*/
describe('#sanitizeInput', () =>{
  it('Removes script tags from string', () =>{
    let test_string = "Something <script>console.log('coolman');</script>"; 
    expect(Validation.sanitizeInput(test_string)).toEqual("Something console.log('coolman');");
  });
  
  const tagsToRemove = ['script', 'embed', 'object', 'iframe', 'frameset', 'meta', 'frame', 'link', 'style']; 

  for (let i = 0; i < tagsToRemove.length; i++){
    let removalTag = tagsToRemove[i];
    let testString = `Something <${removalTag}>test</${removalTag}>`; 
    it(`Should remove: < ${removalTag} /> from string`, () => {
      expect(Validation.sanitizeInput(testString)).toEqual('Something test'); 
    });
  }
});

/**
 * checkForSpaces
 * ============================================================================
*/
describe('#checkForSpaces', () => {
  it('returns true leading space', () =>{
    let testString = " spaces"; 
    expect(Validation.checkForSpaces(testString)).toEqual(true);
  });

  it('returns true trailing spaces', () =>{
    let testString = "spaces "; 
    expect(Validation.checkForSpaces(testString)).toEqual(true);
  });

  it('returns true because there are starting and trailing spaces', () =>{
    let testString = " spaces "; 
    expect(Validation.checkForSpaces(testString)).toEqual(true);
  });

  it('returns true because there are spaces between words', () =>{
    let testString = "spaces in this sentence"; 
    expect(Validation.checkForSpaces(testString)).toEqual(true);
  });

  it('returns false no spaces', () =>{
    let testString = "spacesasdfkasdjhf2129348570,"; 
    expect(Validation.checkForSpaces(testString)).toEqual(false);
  });
});

/**
 * isEmtpy
 * ============================================================================
*/
describe('#isEmpty', () => {
  it('returns true for empty strings', () => {
    let testString = ""; 
    expect(Validation.isEmpty(testString)).toEqual(true);
  });

  it('null should be true', () => {
    let testString = null; 
    expect(Validation.isEmpty(testString)).toEqual(true);
  });

  it('false for numbers', () =>{
    let testString = 1; 
    expect(Validation.isEmpty(testString)).toEqual(false);
  });

  it('false for numbers wrapped in string', () =>{
    let testString = '1'; 
    expect(Validation.isEmpty(testString)).toEqual(false);
  });

  it('true for empty strings', () =>{
    let testString = ' '; 
    expect(Validation.isEmpty(testString)).toEqual(true);
  });

  it('true for empty objects', () =>{
    let test = {}; 
    expect(Validation.isEmpty(test)).toEqual(true);
  });

  it('false object has value', () =>{
    let test = {something: 'cool'}; 
    expect(Validation.isEmpty(test)).toEqual(false);
  });

  it('true for empty array', () =>{
    let test = []; 
    expect(Validation.isEmpty(test)).toEqual(true);
  });

  it('false values', () =>{
    let test = [1,2,3]; 
    expect(Validation.isEmpty(test)).toEqual(false);
  });
});

/**
 * stripHTML
 * ============================================================================
*/
describe('#stripHTML', () =>{
  it('Should remove tag with attributes in it like a link tag', () =>{
    let testString = "A very cool <a href='https://www.google.com' data-value='linking thing' class='someCoolLink' data-controller='stimulusLink'> link </a> ";
    let strippedSpaces = Validation.stripHTML(testString).replace(/\s/gi, ''); 
    expect(strippedSpaces).toEqual("Averycoollink");
  });
  
  const tagsToRemove = ['script', 'embed', 'object', 'iframe', 'frameset', 'meta', 'frame', 'link', 'style', 'bold', 'div', 'p']; 

  for (let i = 0; i < tagsToRemove.length; i++){
    let removalTag = tagsToRemove[i];
    let testString = `Something <${removalTag}>test</${removalTag}>`; 
    it(`Should remove: < ${removalTag} /> from string`, () => {
      expect(Validation.stripHTML(testString)).toEqual('Something test'); 
    });
  }
});

/**
 * validRegex
 * ============================================================================
*/
describe('#validRegex', () =>{
  it('Valid Regex', () =>{
    let testString = "/@(\w+)/g";
    expect(Validation.validRegex(testString)).toEqual(true);
  });
  it('invalid regex', () => { 
    let testString = "[catdog";
    expect(Validation.validRegex(testString)).toEqual(false);
  });
});