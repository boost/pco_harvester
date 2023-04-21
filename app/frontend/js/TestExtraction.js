document.addEventListener('DOMContentLoaded', function () {
  function alertClass(statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return "my-2 alert alert-success"
    } else {
      return "my-2 alert alert-danger";
    }
  }

  function somethingWentWrong() {
    document.getElementById("test-result").innerHTML =
      `<div class="alert alert-danger my-2" role="alert">
        Something went wrong.
      </div>`
  }

  function sendData() {
    const XHR = new XMLHttpRequest();

    // Bind the FormData object and the form element
    const FD = new FormData(form);
    FD.set('_method', 'post')

    // Define what happens on successful data submission
    XHR.addEventListener("load", (event) => {
      if (event.target.status >= 300) {
        somethingWentWrong();
        return;
      }

      const url = JSON.parse(event.target.responseText)['url']
      const status = JSON.parse(event.target.responseText)['status']

      document.getElementById("test-result").innerHTML =
        `<div class="${alertClass(status)}" role="alert">
          <a href="${url}" target="_blank">${url}</a>
        </div>`
    });

    // Define what happens in case of error
    XHR.addEventListener("error", (event) => {
      somethingWentWrong();
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
