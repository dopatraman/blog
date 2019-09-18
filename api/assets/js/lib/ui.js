import ApiClient from "./apiClient";

window.apiClient = new ApiClient();
window.onload = function() {
  const postButton = document.getElementById("create-post");
  postButton.addEventListener("click", (evt) => {
    const title = document.getElementById("title").value;
    const content = document.getElementById("content").value;
    apiClient.createPost(title, content);
  })
}