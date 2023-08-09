// Use this file for importing React apps

import React from "react";
import ReactDOM from "react-dom/client";

import TransformationApp from "/js/apps/TransformationApp/TransformationApp";

import { Provider } from "react-redux";
import configureAppStore from "/js/store";

import ErrorBoundary from "./components/ErrorBoundary";

const transformationAppHTMLElement = document.querySelector(
  "#js-transformation-app"
);

if (transformationAppHTMLElement !== null) {
  const root = ReactDOM.createRoot(transformationAppHTMLElement);
  const props = JSON.parse(transformationAppHTMLElement.dataset.props);

  root.render(
    <React.StrictMode>
      <ErrorBoundary environment={props.config.environment}>
        <Provider store={configureAppStore(props)}>
          <TransformationApp />
        </Provider>
      </ErrorBoundary>
    </React.StrictMode>
  );
}

// Extraction App

import ExtractionApp from "/js/apps/ExtractionApp/ExtractionApp";
import configureExtractionAppStore from "/js/extractionStore";

const extractionAppHTMLElement = document.querySelector("#js-extraction-app");

if (extractionAppHTMLElement !== null) {
  const root = ReactDOM.createRoot(extractionAppHTMLElement);
  const props = JSON.parse(extractionAppHTMLElement.dataset.props);

  root.render(
    <React.StrictMode>
      <ErrorBoundary environment={props.config.environment}>
        <Provider store={configureExtractionAppStore(props)}>
          <ExtractionApp />
        </Provider>
      </ErrorBoundary>
    </React.StrictMode>
  );
}
