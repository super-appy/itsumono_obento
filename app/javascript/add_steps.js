document.addEventListener('cocoon:after-insert', function(e) {
  updateSteps();
});

document.addEventListener('cocoon:after-remove', function(e) {
  updateSteps();
});

document.addEventListener("turbo:load", function() {
  updateSteps();
});


function updateSteps() {
  document.querySelectorAll('.step-index').forEach((element, index) => {
    // 空の場合だけ設定
    if(element.value === null || element.value === "" || element.value === undefined){
      element.value = index + 1;
    }
  });
}

