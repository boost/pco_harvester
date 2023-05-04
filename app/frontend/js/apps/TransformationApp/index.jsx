import React from 'react';

import RecordViewer from '~/js/apps/TransformationApp/components/RecordViewer';

const TransformationApp = ({rawRecord, transformedRecord, attributes}) => {
  return (
    <React.Fragment>
 
      <div className="row">
        <div className="col align-self-start">
          <RecordViewer record={rawRecord} />
        </div>

        <div className="col align-self-center">
          <RecordViewer record={transformedRecord} />
        </div>
      </div>

      <div className="mt-4"></div>

      <div className="accordion accordion-flush">
        <div className="accordion-item">
          <h2 className="accordion-header">
            <button className="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseOne" aria-expanded="false" aria-controls="flush-collapseOne">
              title
            </button>
          </h2>
          <div id="flush-collapseOne" className="accordion-collapse collapse" data-bs-parent="#accordionFlushExample">
            <div className="accordion-body">

              <div id="js-attribute-editor" data-block="def hello_world
        p 'hello'
      end"></div>

              <div className='mt-4 float-end'>
                <button type="submit" className="btn btn-danger">Delete</button>
                <button type="submit" className="btn btn-primary">Save</button>
                <button type="submit" className="btn btn-success">Run</button>
              </div>

              <div className="clearfix"></div>
            </div>
          </div>
        </div>
      </div>

    </React.Fragment>
  );
};

export default TransformationApp;
