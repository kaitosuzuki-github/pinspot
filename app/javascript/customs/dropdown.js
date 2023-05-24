document.addEventListener("turbo:load", dropdown, false);

function dropdown() {
  const dropdownWrapList = document.querySelectorAll("#dropdownWrap");
  if (dropdownWrapList.length == 0) {
    return;
  }
  const dropdownMenuList = [];
  dropdownWrapList.forEach(function (element) {
    const dropdownToggle = element.querySelector("#dropdownToggle");
    const dropdownMenu = element.querySelector("#dropdownMenu");
    dropdownToggle.addEventListener(
      "click",
      () => {
        dropdownMenu.classList.toggle("dropdown-invisible");
        dropdownMenu.classList.toggle("dropdown-visible");
      },
      false
    );
    dropdownMenuList.push(dropdownMenu);
  });
  document.addEventListener(
    "click",
    (e) => {
      if (!e.target.closest("#dropdownWrap")) {
        dropdownMenuList.forEach(function (element) {
          element.classList.add("dropdown-invisible");
        });
      }
    },
    false
  );
}
