document.addEventListener("DOMContentLoaded", imagePreview, false);
document.addEventListener("turbo:render", imagePreview, false);

function imagePreview() {
  const fileInput = document.getElementById("fileInput");
  if (fileInput != null) {
    fileInput.addEventListener("change", setImage, false);
  }
}

function setImage(e) {
  let image = document.getElementById("image");
  const file = e.currentTarget.files[0];
  image.setAttribute("src", URL.createObjectURL(file));
}
