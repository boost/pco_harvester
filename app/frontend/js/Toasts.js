import { Toast } from "bootstrap";

const toastElList = document.querySelectorAll(".toast");
const toastList = [...toastElList].map((toastEl) => new Toast(toastEl).show());
