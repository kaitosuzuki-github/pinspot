document.addEventListener("DOMContentLoaded", imagePreview, false);
document.addEventListener("turbo:render", imagePreview, false);

function imagePreview() {
  const fileInput = Array.from(document.querySelectorAll('input[type="file"]'));
  if (fileInput == null) {
    return;
  }
  fileInput.forEach(function (element) {
    const fileInputId = element.getAttribute("id");
    if (fileInputId != null) {
      const imageId = fileInputId + "_preview";
      element.addEventListener(
        "change",
        { imageId: imageId, handleEvent: setImage },
        false
      );
    }
  });
}

function setImage(e) {
  const imageId = this.imageId;
  const image = document.getElementById(imageId);
  if (image == null) {
    return;
  }
  const file = e.currentTarget.files[0];
  if (file.type.indexOf("image") != -1) {
    image.setAttribute("src", URL.createObjectURL(file));
    if (imageId.indexOf("profile") >= 0) {
      image.setAttribute("class", "h-full w-full object-cover");
    }
  }
}
