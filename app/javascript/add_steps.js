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
  const stepFields = document.querySelectorAll('.step-nested-fields');
  const lastIndex = stepFields.length - 1;

  stepFields.forEach((field, index) => {
    const stepIndexInput = field.querySelector('.step-index');
    const removeButton = field.querySelector('.remove-step');

    //手順４以降は一番最後の行にだけ削除ボタンを表示
    if(index !== lastIndex || index <= 2){
      removeButton.style.display = 'none';
    }else{
      removeButton.style.display = 'block';
    }

    // 空の場合だけ設定
    if(stepIndexInput.value === null || stepIndexInput.value === "" || stepIndexInput.value === undefined){
      stepIndexInput.value = index + 1;
    }
  });
}

