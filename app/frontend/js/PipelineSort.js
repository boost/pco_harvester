const selectElement = document.getElementById("js-pipeline-sort");

if (selectElement) {
  const form = selectElement.closest("form");

  selectElement.addEventListener("change", () => {
    form.submit();
  });
}
