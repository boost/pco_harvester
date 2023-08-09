import { bindTestForm } from "./utils/test-form";
import editor from "./editor";
import xmlFormat from "xml-formatter";

bindTestForm(
  "test_enrichment_extraction",
  "js-test-enrichment-extraction-button",
  "js-extraction-definition-form",
  (response, _alertClass) => {
    let results = response.data.body;
    let format = document.querySelector("#extraction_definition_format").value;

    if (format == "JSON") {
      results = JSON.stringify(response.data.body, null, 2);
    } else if (format == "XML") {
      results = xmlFormat(response.data.body, {
        indentation: "  ",
        lineSeparator: "\n",
      });
    }

    editor("#js-enrichment-extraction-result", format, true, results);
  },
  (error) => {
    document.querySelector("#js-enrichment-extraction-result").innerHTML = "";
    document.getElementById(
      "js-enrichment-extraction-result"
    ).innerHTML = `<div class="alert alert-danger my-2" role="alert">
    Something went wrong fetching your enrichment from the Enrichment URL. Please confirm that your Enrichment URL is correct.
  </div>`;
  }
);
