document.addEventListener('cocoon:after-insert', function(e) {
  updateSteps();
});

document.addEventListener('cocoon:after-remove', function(e) {
  updateSteps();
});

document.addEventListener("DOMContentLoaded", function(e){
  updateSteps();
});

function updateSteps() {
  document.querySelectorAll('.step-nested-fields').forEach(function(element, index) {
    var stepIndexElement = element.querySelector(".step-index");
    if (stepIndexElement) {
      stepIndexElement.textContent = index + 1;
    }
  });
}

