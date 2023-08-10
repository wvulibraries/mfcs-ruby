import change from "events/change";

describe('trigger change event', () => {
  // Setup a document to test
  document.body.innerHTML =
    '<div>' +
    '  <input type="text" id="input" />' +
    '</div>';

  // the goal is to setup an event that logs to the "console" then manually trigger the event without
  // changing on the button and by using the change function we have created.
  document.getElementById('input').addEventListener("change", () => { 
    console.log('helloChange');
    document.getElementById('input').value = 'Changed Value';   
  });

  // clear the mock functions after each test
  beforeEach(()=>{
    document.getElementById('input').value = '';
  });
  afterEach(() => {
    jest.clearAllMocks();
  });

  // Run the test expectations.
  it('forces the change', () => {
    const consoleSpy = jest.spyOn(console, 'log');
    change(document.getElementById('input'));
    expect(consoleSpy).toHaveBeenCalledWith('helloChange');
    expect(consoleSpy).toHaveBeenCalledTimes(1);
    expect(document.getElementById('input').value).toEqual('Changed Value'); 
  });

  it('should not have been changed so console, should never have been called', () => {
    const consoleSpy = jest.spyOn(console, 'log');
    expect(document.getElementById('input').value).toBeFalsy();
    expect(consoleSpy).toHaveBeenCalledTimes(0);
  });
});