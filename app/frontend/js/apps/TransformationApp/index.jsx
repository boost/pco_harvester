import React from 'react';

const TransformationApp = () => {
  return (
    <React.Fragment>
  
      <div className="row">

        <div className="col align-self-start">
          <div className="record-view record-view--transformation">
            Raw Record Viewer
          </div>
        </div>


        <div className="col align-self-center">
          <div className="record-view record-view--transformation">
            Transformed Record Viewer
          </div>
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
