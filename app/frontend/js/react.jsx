// Use this file for importing React apps

import React from 'react';
import ReactDOM from 'react-dom/client';

import TransformationApp from '~/js/apps/TransformationApp';

const root = ReactDOM.createRoot(document.getElementById('js-transformation-app'));

root.render(
  <React.StrictMode>
    <TransformationApp />
  </React.StrictMode>
);

