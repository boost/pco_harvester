import React from "react";

const ExpandCollapseIcon = ({ expanded, vertical }) => {
  if (expanded) {
    const direction = vertical ? "up" : "left";
    return (
      <i className={`bi bi-arrow-bar-${direction}`} aria-label="collapse"></i>
    );
  } else {
    const direction = vertical ? "down" : "right";
    return (
      <i className={`bi bi-arrow-bar-${direction}`} aria-label="expand"></i>
    );
  }
};

export default ExpandCollapseIcon;
