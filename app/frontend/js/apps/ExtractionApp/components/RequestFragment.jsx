import React from 'react';

import { useSelector, useDispatch } from "react-redux";
import { selectParameterById, updateParameter, deleteParameter } from "~/js/features/ExtractionApp/ParametersSlice";

const RequestFragment = ({ id, index }) => {
  const { name, content, dynamic, kind } = useSelector((state) => selectParameterById(state, id));

  const prefix = () => {
    if(kind == 'slug') {
      return '/';
    }

    if(index == 0) {
      return '?'
    }

    return '&';
  }

  const value = () => {
    if(kind == 'slug') {
      return content;
    }

    if(name == '' || content == '') {
      return '';
    }

    return `${name}=${content}`
  }

  return(
    <span>
      { prefix() }{ value() }
    </span>
  )
}

export default RequestFragment;
