// Use this file for importing React apps

import React from "react";
import ReactDOM from "react-dom/client";

import TransformationApp from "~/js/apps/TransformationApp";

import { Provider } from "react-redux";
import configureAppStore from "~/js/store";

const transformationAppHTMLElement = document.querySelector(
  "#js-transformation-app"
);

const root = ReactDOM.createRoot(transformationAppHTMLElement);
const props = JSON.parse(transformationAppHTMLElement.dataset.props);

root.render(
  <React.StrictMode>
    <Provider store={configureAppStore(props)}>
      <TransformationApp />
    </Provider>
  </React.StrictMode>
);
