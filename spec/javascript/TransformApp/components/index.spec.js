import React from 'react'
import { fireEvent, screen } from '@testing-library/react'
import TransformationApp from 'js/apps/TransformationApp/index';
import { renderWithProviders } from '../../test-utils';

describe("<TransformationApp />", () => {
  it("runs", () => {
    renderWithProviders(<TransformationApp />);

    
  });
});
