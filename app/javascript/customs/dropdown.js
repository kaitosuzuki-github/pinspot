document.addEventListener("turbo:load", dropdown, false);
document.addEventListener("turbo:frame-load", dropdown, false);

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
        dropdownMenu.classList.toggle("fade-out");
        dropdownMenu.classList.toggle("fade-in");
        element.classList.add(dropdownNum);
      },
      false
    );

    document.addEventListener(
      "click",
      (e) => {
        if (!e.target.closest("." + dropdownNum)) {
          dropdownMenu.classList.add("fade-out");
        }
      },
      false
    );
  });
}
