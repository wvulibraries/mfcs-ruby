import Validation from "validation/validation";

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
  'ftp://www.example.org/' 
]

const invalid_test_urls = [ 
  'www.google.com?12i4',
  'monkeyPatch',
  'http://.org'
]

describe("Invalid Urls", ()=> { 
  // Invalid
  for(let i = 0; i < invalid_test_urls.length; i++) {
    it('Invalid Test: ' + invalid_test_urls[i], () => {   
      expect(Validation.validUrl(invalid_test_urls[i])).toEqual(false); 
    });
  }
  // Valid
  for(let i = 0; i < valid_test_urls.length; i++) {
    it('Valid Test: ' + valid_test_urls[i], () => {   
      expect(Validation.validUrl(valid_test_urls[i])).toEqual(true); 
    });
  }
});