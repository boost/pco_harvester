document.addEventListener('DOMContentLoaded', function () {
  function sendData() {
    const XHR = new XMLHttpRequest();

    // Bind the FormData object and the form element
    const FD = new FormData(form);
    FD.set('_method', 'post')

    // Define what happens on successful data submission
    XHR.addEventListener("load", (event) => {
      document.getElementById("test-result").textContent =
        JSON.stringify(JSON.parse(event.target.responseText), null, 2)
    });

    // Define what happens in case of error
    XHR.addEventListener("error", (event) => {
      alert('Oops! Something went wrong.');
    });

    // Set up our request
    XHR.open("POST", `${form.action}/test`);

    // The data sent is what the user provided in the form
    XHR.send(FD);
  }

  const button = this.getElementById('test-extraction');
  const form = button.closest("form");
  button.addEventListener("click", (event) => {
    sendData();
  });
}, false);
