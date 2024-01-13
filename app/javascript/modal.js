document.addEventListener("turbo:load", () => {
  // 特定のページ特有の要素をチェック
  const submitButton = document.getElementById('openModal');
  if (!submitButton) return; // 要素が存在しなければ以降のコードは実行しない

  const modalArea = document.getElementById('modalArea');

  // フォーム送信時にモーダルを表示
  submitButton.addEventListener('click', function (e) {
    showModal(modalArea);
  });

  function showModal(modal) {
    // モーダル表示の処理
    modal.classList.remove('hidden');
    setTimeout(() => modal.classList.remove('opacity-0'), 10);
  }

  // モーダル非表示の関数は、後でRailsのコントローラから呼び出すためにグローバルに公開
  window.hideModal = function (modal) {
    // モーダル非表示の処理
    modal.classList.add('opacity-0');
    modal.addEventListener('transitionend', function handler() {
      modal.classList.add('hidden');
      modal.removeEventListener('transitionend', handler);
    });
  };
});
