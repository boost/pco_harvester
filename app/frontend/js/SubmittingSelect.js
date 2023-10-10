const selectElements = document.querySelectorAll(
  '[data-submitting-select="true"]'
);

selectElements.forEach(function (selectElement) {
  const form = selectElement.closest("form");

  selectElement.addEventListener("change", () => {
    form.submit();
  });
});
