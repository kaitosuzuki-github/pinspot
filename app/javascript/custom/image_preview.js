document.addEventListener("DOMContentLoaded", imagePreview, false);
document.addEventListener("turbo:render", imagePreview, false);

function imagePreview() {
  let fileInput = Array.from(document.querySelectorAll('input[type="file"]'));
  if (fileInput != null) {
    fileInput.forEach(function (element) {
      const fileInputId = element.getAttribute("id");
      const imageId = fileInputId + "_preview";
      element.addEventListener(
        "change",
        { imageId: imageId, handleEvent: setImage },
        false
      );
    });
  }
}

function setImage(e) {
  const image = document.getElementById(this.imageId);
  const file = e.currentTarget.files[0];
  if (file.type.indexOf("image") == 0) {
    image.setAttribute("src", URL.createObjectURL(file));
  }
}
