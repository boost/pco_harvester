const scheduleFrequencySelect = document.getElementById(
  "js-schedule-frequency-select"
);

const scheduleWeekly = document.getElementById(
  "js-schedule-weekly"
);

const scheduleMonthly = document.getElementById(
  "js-schedule-monthly"
);

const scheduleBiMonthly = document.getElementById(
  "js-schedule-bi-monthly"
);

const scheduleRunLabel = document.getElementById(
  'js-schedule-run-label'
)


if(scheduleFrequencySelect) {
  hideDynamicFrequencyInputs();

  scheduleFrequencyLogic(scheduleFrequencySelect.value);

  scheduleFrequencySelect.addEventListener("change", (event) => { 
    scheduleFrequencyLogic(event.target.value);
  });
}

function scheduleFrequencyLogic(frequency) {
  hideDynamicFrequencyInputs();
  
  if(frequency == 'daily') {
    scheduleRunLabel.innerHTML = 'Run daily at';
  } else if(frequency == 'weekly') {
    scheduleRunLabel.innerHTML = 'Run weekly at';
    scheduleWeekly.style.display = 'inline-block';
  } else if(frequency == 'bi_monthly') {
    scheduleRunLabel.innerHTML = 'Run monthly at';
    scheduleBiMonthly.style.display = 'inline-block';
  }else if(frequency == 'monthly') {
    scheduleRunLabel.innerHTML = 'Run monthly at';
    scheduleMonthly.style.display = 'inline-block';
  }
}

function hideDynamicFrequencyInputs() {
  scheduleWeekly.style.display = 'none';
  scheduleBiMonthly.style.display = 'none';
  scheduleMonthly.style.display = 'none';
}