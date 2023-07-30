import axios from "axios";

export function csrfParam() {
  const csrfParamDOMElement = document.head.querySelector(
    "[name=csrf-param][content]"
  );

  if (csrfParamDOMElement) {
    return csrfParamDOMElement.content;
  } else {
    return "";
  }
}

export function csrfToken() {
  const csrfTokenDOMElement = document.head.querySelector(
    "[name=csrf-token][content]"
  );

  if (csrfTokenDOMElement) {
    return csrfTokenDOMElement.content;
  } else {
    return "";
  }
}

export const request = axios.create({
  headers: { "X-CSRF-Token": csrfToken() },
});
