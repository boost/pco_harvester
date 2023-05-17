import React, { useEffect, useRef } from "react";
import { Tooltip as BsTooltip } from "bootstrap";

const Tooltip = ({ children, ...props }) => {
  const tooltipRef = useRef();

  useEffect(() => {
    new BsTooltip(tooltipRef.current);
  }, []);

  return (
    <span data-bs-toggle="tooltip" {...props} ref={tooltipRef}>
      {children}
    </span>
  );
};

export default Tooltip;
