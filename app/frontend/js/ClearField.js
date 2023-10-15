const clearButtons = document.querySelectorAll("[data-clear-field]");

clearButtons.forEach(function (clearButton) {
  clearButton.addEventListener("click", (event) => {
    const form = event.target.closest("form");
    const fieldNameToClear = event.target.dataset.clearField;
    const fieldToClear = form.querySelector(
      `input[name="${fieldNameToClear}"]`
    );

    fieldToClear.value = "";
    form.submit();
  });
});
