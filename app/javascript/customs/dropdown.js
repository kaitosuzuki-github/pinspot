document.addEventListener("DOMContentLoaded", dropdown, false);
document.addEventListener("turbo:render", dropdown, false);

function dropdown() {
  const dropdownWrapList = document.querySelectorAll("#dropdownWrap");
  if (dropdownWrapList.length == 0) {
    return;
  }
  dropdownWrapList.forEach(function (element, index) {
    const dropdownToggle = element.querySelector("#dropdownToggle");
    const dropdownMenu = element.querySelector("#dropdownMenu");
    const dropdownNum = "dropdown" + index;
    dropdownToggle.addEventListener(
      "click",
      () => {
        dropdownMenu.classList.toggle("dropdown-invisible");
        dropdownMenu.classList.toggle("dropdown-visible");
        element.classList.add(dropdownNum);
      },
      false
    );

    document.addEventListener(
      "click",
      (e) => {
        if (!e.target.closest("." + dropdownNum)) {
          dropdownMenu.classList.add("dropdown-invisible");
        }
      },
      false
    );
  });
}
