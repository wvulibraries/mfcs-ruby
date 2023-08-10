import click from "events/click";

describe('trigger click event', () => {
  // Setup a document to test
  document.body.innerHTML =
    '<div>' +
    '  <button id="button" />' +
    '</div>';

  // the goal is to setup an event that logs to the "console" then manually trigger the event without
  // clicking on the button and by using the click function we have created.
  document.getElementById('button').addEventListener("click", () => { console.log('helloClick') });

  // clear the mock functions after each test
  afterEach(() => {
    jest.clearAllMocks();
  });

  // Run the test expectations.
  it('forces the click', () => {
    const consoleSpy = jest.spyOn(console, 'log');
    click(document.getElementById('button'));
    expect(consoleSpy).toHaveBeenCalledWith('helloClick');
    expect(consoleSpy).toHaveBeenCalledTimes(1);
  });

  it('should not have been clicked', () => {
    const consoleSpy = jest.spyOn(console, 'log');
    expect(consoleSpy).toHaveBeenCalledTimes(0);
  });
});