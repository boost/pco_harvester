import { Toast } from "bootstrap";

const toastElList = document.querySelectorAll(".toast");

console.log(toastElList);
const toastList = [...toastElList].map((toastEl) => new Toast(toastEl).show());
