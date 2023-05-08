import axios, { isCancel, AxiosError } from "axios";

export function csrfParam() {
  return document.head.querySelector("[name=csrf-param][content]").content;
}

export function csrfToken() {
  return document.head.querySelector("[name=csrf-token][content]").content;
}

export const request = axios.create({
  headers: { "X-CSRF-Token": csrfToken() },
});
