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
    // 仮の値を設定する例
  document.querySelectorAll('.step-index').forEach((element, index) => {
    // ここで設定する値は、実際のアプリケーションロジックに基づく必要があります。
    element.value = index + 1; // 例えば、インデックスに1を加えた値を設定
  });
}

