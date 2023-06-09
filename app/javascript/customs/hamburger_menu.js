document.addEventListener("turbo:load", hamburger_menu, false);

function hamburger_menu() {
  const hamMenuToggle = document.getElementById("hamMenuToggle");
  const hamMenuClose = document.getElementById("hamMenuClose");
  const hamMenu = document.getElementById("hamMenu");

  hamMenuToggle.addEventListener(
    "click",
    () => {
      hamMenu.classList.toggle("fade-out");
      hamMenu.classList.toggle("fade-in");
      hamMenuClose.classList.toggle("hidden");
      hamMenuToggle.classList.toggle("hidden");
    },
    false
  );

  hamMenuClose.addEventListener(
    "click",
    () => {
      hamMenu.classList.toggle("fade-out");
      hamMenu.classList.toggle("fade-in");
      hamMenuClose.classList.toggle("hidden");
      hamMenuToggle.classList.toggle("hidden");
    },
    false
  );
}
