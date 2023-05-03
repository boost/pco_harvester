// Use this file for importing React apps

import React from 'react';
import ReactDOM from 'react-dom';

import TransformationApp from 'js/apps/TransformationApp';

ReactDOM.render(
  <React.StrictMode>
    <TransformationApp />
  </React.StrictMode>,
  document.getElementById('js-transformation-app')
);
