import React from 'react'
import { fireEvent, screen } from '@testing-library/react'
import { act } from 'react-dom/test-utils';
import TransformationApp from 'js/apps/TransformationApp/TransformationApp';
import { renderWithProviders } from '../../test-utils';

// This issue solves the error 'textRange(...).getClientRects'
// Which appears to be an issue between Jest / React and CodeMirror
// https://github.com/jsdom/jsdom/issues/3002

document.createRange = () => {
  const range = new Range();

  range.getBoundingClientRect = jest.fn();

  range.getClientRects = () => {
    return {
      item: () => null,
      length: 0,
      [Symbol.iterator]: jest.fn()
    };
  };

  return range;
}

/////////////////////////////////////////////////////

describe("<TransformationApp />", () => {
  beforeEach(() => {
    const initialFields = {
      ids: [1, 2,],
      entities: {
        1: {
          id: 1,
          name: 'title',
          block: 'record["title"]'
        },
        2: {
          id: 2,
          name: 'description',
          block: 'record["description"]'
        }
      }
    }

    const initialAppDetails = {
      rawRecord: {
        record_id: 1,
        title: 'title',
        description: 'description',
        reference_number: '12032',
        source: 'source'
      },
      transformedRecord: {
        record_id: 1,
        title: 'title',
        description: 'description'
      },
      contentPartner: {
        id: 1
      },
      transformationDefinition: {
        id: 1
      }
    }

    const initialUiFields = {
      ids: [1, 2],
      entities: {
        1: {
          id: 1,
          saved: true,
          deleting: false
        },
        2: {
          id: 2,
          saved: true,
          deleting: false
        }
      }
    }
    
    renderWithProviders(<TransformationApp />, {
      preloadedState: {
        entities: {
          fields: initialFields,
          appDetails: initialAppDetails
        },
        ui: {
          fields: initialUiFields
        }
      }
    });
  });

  it("displays the raw record", () => {
    expect(screen.queryByText("Raw")).toBeTruthy();
  });
  
  it("displays the transformed record", () => {
    expect(screen.queryByText("Transformed")).toBeTruthy();
  });

  it("displays the fields for the transformation", () => {
    expect(screen.queryByText("Fields")).toBeTruthy();
    const fields = screen.getAllByTestId('field');
    expect(fields).toHaveLength(2);
  })

  it("adds an additional field to the transformation when Add Field is clicked", async () => {

    let fields = screen.getAllByTestId('field');
    expect(fields).toHaveLength(2);

    const button = screen.getByText('Add Field');
    fireEvent.click(button)

    expect(await screen.findAllByText('Additional Field')).toBeTruthy();
  })
});
