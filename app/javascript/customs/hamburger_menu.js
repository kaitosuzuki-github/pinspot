document.addEventListener("turbo:load", hamburger_menu, false);

function hamburger_menu() {
  const hamMenuToggle = document.getElementById("hamMenuToggle");
  const hamMenuClose = document.getElementById("hamMenuClose");
  const hamMenu = document.getElementById("hamMenu");

  hamMenuToggle.addEventListener(
    "click",
    () => {
      hamMenu.classList.toggle("opacity-0");
      hamMenu.classList.toggle("opacity-100");
      hamMenuClose.classList.toggle("hidden");
      hamMenuToggle.classList.toggle("hidden");
    },
    false
  );

  hamMenuClose.addEventListener(
    "click",
    () => {
      hamMenu.classList.toggle("opacity-0");
      hamMenu.classList.toggle("opacity-100");
      hamMenuClose.classList.toggle("hidden");
      hamMenuToggle.classList.toggle("hidden");
    },
    false
  );
}
