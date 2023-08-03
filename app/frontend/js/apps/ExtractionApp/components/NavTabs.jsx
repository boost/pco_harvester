import React from 'react';
import { createPortal } from 'react-dom';

const NavTabs = () => {
    return createPortal(
    <>
      <ul class="nav nav-tabs mt-4" role="tablist">
        <li class="nav-item" role="presentation">
          <button class="nav-link active" type="button" role="tab" aria-selected="true">
            Initial Request
          </button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link" type="button" role="tab" aria-selected="false">
            Main Request
          </button>
        </li>
      </ul>
    </>,
    document.getElementById("react-nav-tabs")
  );
}

export default NavTabs;

