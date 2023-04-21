const fileInput = document.getElementById("fileInput");
const image = document.getElementById("image");

fileInput.addEventListener("change", (e) => {
  const file = e.target.files[0];
  image.setAttribute("src", URL.createObjectURL(file));
});
