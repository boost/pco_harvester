import React, { Component } from "react";

class ErrorBoundary extends Component {
  constructor(props) {
    super(props);

    this.state = { hasError: false };

    this.developmentRender = this.developmentRender.bind(this);
  }

  componentDidCatch(error, info) {
    // Display fallback UI
    this.setState({ hasError: true, error: error });

    // eslint-disable-next-line no-console
    console.error(error, info);
  }

  developmentRender() {
    return (
      <>
        <h1>[DEVELOPMENT] AN ERROR OCCURED</h1>
        <p className="callout callout-warning">{this.state.error.message}</p>
        <pre>
          <code className="code-block">{this.state.error.stack}</code>
        </pre>
      </>
    );
  }

  render() {
    if (!this.state.hasError) {
      return this.props.children;
    }

    if (this.props.environment == "development") {
      return this.developmentRender();
    }

    return (
      // taken from 500.html.haml
      <div className="container">
        <div className="row">
          <h1 className="col">We're sorry</h1>
          <p className="col">
            But something went wrong, we've been notified about this issue and
            we'll take a look at it shortly.
          </p>
          <ul className="col">
            <li>
              <a href="/">Homepage</a>
            </li>
          </ul>
          <h4 className="col">Thank you</h4>
        </div>
      </div>
    );
  }
}

export default ErrorBoundary;
