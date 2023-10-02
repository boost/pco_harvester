const scheduleFrequencySelect = document.getElementById(
  "js-schedule-frequency-select"
);

const scheduleWeekly = document.getElementById("js-schedule-weekly");

const scheduleMonthly = document.getElementById("js-schedule-monthly");

const scheduleBiMonthly = document.getElementById("js-schedule-bi-monthly");

const scheduleRunLabel = document.getElementById("js-schedule-run-label");

if (scheduleFrequencySelect) {
  hideDynamicFrequencyInputs();

  scheduleFrequencyLogic(scheduleFrequencySelect.value);

  scheduleFrequencySelect.addEventListener("change", (event) => {
    scheduleFrequencyLogic(event.target.value);
  });
}

function scheduleFrequencyLogic(frequency) {
  hideDynamicFrequencyInputs();

  if (frequency == "daily") {
    scheduleRunLabel.innerText = "Run daily at";
  } else if (frequency == "weekly") {
    scheduleRunLabel.innerText = "Run weekly at";
    scheduleWeekly.classList.remove('d-none');
  } else if (frequency == "bi_monthly") {
    scheduleRunLabel.innerText = "Run monthly at";
    scheduleBiMonthly.classList.remove('d-none');
  } else if (frequency == "monthly") {
    scheduleRunLabel.innerText = "Run monthly at";
    scheduleMonthly.classList.remove('d-none');
  }
}

function hideDynamicFrequencyInputs() {
  scheduleWeekly.classList.add('d-none');
  scheduleBiMonthly.classList.add('d-none');
  scheduleMonthly.classList.add('d-none');
}
