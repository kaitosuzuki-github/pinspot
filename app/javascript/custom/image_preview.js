document.addEventListener(
  "turbo:load",
  function () {
    const fileInput = document.getElementById("fileInput");
    if (fileInput != null) {
      fileInput.addEventListener("change", imagePreview, false);
    }
  },
  false
);

function imagePreview(e) {
  let image = document.getElementById("image");
  const file = e.currentTarget.files[0];
  image.setAttribute("src", URL.createObjectURL(file));
}
