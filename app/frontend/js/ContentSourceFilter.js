const contentSourceFilter = document.getElementById("js-content-source-filter");

if (contentSourceFilter) {
  const form = contentSourceFilter.closest("form");

  contentSourceFilter.addEventListener("change", (event) => {
    form.submit();
  });
}
