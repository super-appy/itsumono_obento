// // これだと動かないのでキャンセルボタンの実装は見送り?

// document.addEventListener('DOMContentLoaded', () => {
//   // 全てのキャンセルボタンを選択　※ここの要素が取れてないことが発覚！！！
//   const cancelButtons = document.querySelectorAll('#cancel_button');
//   console.log(cancelButtons, 'button')
//   // 各キャンセルボタンにイベントリスナーを設定
//   cancelButtons.forEach(button => {
//     button.addEventListener('click', () => {
//       // クリックされたボタンの親要素であるフラッシュメッセージを非表示にする
//       button.closest('.flash_message').style.display = 'none';
//     });
//   });
// });
