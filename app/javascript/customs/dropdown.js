document.addEventListener("turbo:load", dropdown, false);

function dropdown() {
  const dropdownToggle = document.getElementById("dropdownToggle");
  if (dropdownToggle != null) {
    const dropdownMenu = document.getElementById("dropdownMenu");
    dropdownToggle.addEventListener(
      "click",
      () => {
        dropdownMenu.classList.toggle("dropdown-invisible");
        dropdownMenu.classList.toggle("dropdown-visible");
      },
      false
    );
    document.addEventListener(
      "click",
      (e) => {
        if (!e.target.closest("#dropdownWrap")) {
          dropdownMenu.classList.add("dropdown-invisible");
        }
      },
      false
    );
  }
}
