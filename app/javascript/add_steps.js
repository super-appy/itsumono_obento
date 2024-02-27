document.addEventListener('cocoon:after-insert', function(e) {
  updateUI();
});

document.addEventListener('cocoon:after-remove', function(e) {
  updateUI();
});

document.addEventListener("turbo:load", function() {
  updateUI();
});

function updateUI() {
  updateSteps(); // 既存のステップ更新処理
  addButtons(); // ボタンの追加処理もここに統合
}

function addButtons() {
  // addButtonsの中身を、競合を避けるように調整
  const addStepButton = document.querySelector('.add-step-button'); // querySelectorAllからquerySelectorに変更
  const addIngButton = document.querySelector('.add-ing-button'); // 同上
  
  const stepFields = document.querySelectorAll('.step-nested-fields');
  const ingFields = document.querySelectorAll('.ing-nested-fields');
  
  const maxStep = 5;
  const maxIng = 8;
  
  if(stepFields.length >= maxStep) {
    addStepButton.style.display = 'none';
  } else {
    addStepButton.style.display = 'block';
  }

  if(ingFields.length >= maxIng) {
    addIngButton.style.display = 'none';
  } else {
    addIngButton.style.display = 'block';
  }
}

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