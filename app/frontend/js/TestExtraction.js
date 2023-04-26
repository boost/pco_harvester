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

  function sendData(form) {
    // Bind the FormData object and the form element
    const FD = new FormData(form);
    FD.set('_method', 'post')

    const path = `${form.action.replace(/\/\d+$/, '')}/test`;
    // Fetches the response
    fetch(path, {
      method: 'POST',
      body: FD
    }).then(function(response) {
      return response.ok ? response.json() : Promise.reject()
    })
    .then(function(data) {
      document.getElementById("test-result").innerHTML =
        `<div class="${alertClass(data.status)}" role="alert">
          <a href="${data.url}" target="_blank">${data.url}</a>
        </div>`
    }).catch(function(error) {
      somethingWentWrong();
    })
  }

  const button = this.getElementById('test-extraction');
  const form = button.closest("form");
  button.addEventListener("click", (event) => {
    sendData(form);
  });
}, false);
