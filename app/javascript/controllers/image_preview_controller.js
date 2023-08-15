import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image", "avatar"];

  setImage(event) {
    const file = event.target.files[0];
    if (file.type.indexOf("image") != -1) {
      this.imageTarget.setAttribute("src", URL.createObjectURL(file));
    }
  }

  setProfileImage(event) {
    const file = event.target.files[0];
    if (file.type.indexOf("image") != -1) {
      this.imageTarget.setAttribute("src", URL.createObjectURL(file));
      this.imageTarget.setAttribute("class", "h-full w-full object-cover");
      if (this.hasAvatarTarget) {
        this.avatarTarget.remove();
      }
    }
  }
}
