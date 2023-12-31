(function () {
  // モーダルボタンとモーダルエリアの全要素を取得
  const modalButtons = document.querySelectorAll('[id^="openModal"]');
  const modalAreas = document.querySelectorAll('.modalArea');
  const modalBgs = document.querySelectorAll('[id^="modalBg"]');

  // 各ボタンにイベントリスナーを設定
  modalButtons.forEach(button => {
    button.addEventListener('click', function () {
      const index = this.id.replace('openModal', '');
      const modal = document.querySelector(`#modalArea${index}`);
      showModal(modal);
    });
  });

  // 閉じるボタンと背景クリックのイベントも設定
  modalAreas.forEach(area => {
    const closeModal = area.querySelector('.closeModal');
    closeModal.addEventListener('click', () => hideModal(area));
  });

  modalBgs.forEach(bg => {
    bg.addEventListener('click', () => {
      const modal = bg.closest('.modalArea');
      hideModal(modal);
    });
  });

  function showModal(modal) {
    // モーダル表示の処理
    modal.classList.remove('hidden');
    setTimeout(() => modal.classList.remove('opacity-0'), 10);
  }

  function hideModal(modal) {
    // モーダル非表示の処理
    modal.classList.add('opacity-0');
    modal.addEventListener('transitionend', function handler() {
      modal.classList.add('hidden');
      modal.removeEventListener('transitionend', handler);
    });
  }
}());
