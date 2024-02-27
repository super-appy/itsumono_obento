
document.addEventListener("turbo:load", () => {
  const menuButton = document.querySelector('.menu-button');
  const menu = document.querySelector('.menu');

  menuButton.addEventListener('click', function() {
    menu.classList.toggle('hidden'); // メニューの表示/非表示を切り替え
    this.classList.toggle('fa-bars'); // メニューボタンアイコンを切り替え
    this.classList.toggle('fa-xmark'); // クローズボタンアイコンを切り替え
  });
});

