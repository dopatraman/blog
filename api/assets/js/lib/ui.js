import ApiClient from "./apiClient";

window.onload = function() {
  const apiClient = new ApiClient();
  const postButton = document.getElementById("create-post");
  if (postButton !== null) {
    postButton.addEventListener("click", (evt) => {
      const title = document.getElementById("title").value;
      const content = document.getElementById("content").value;
      apiClient.createPost(title, content);
    })
  }

  const anonPostButton = document.getElementById("create-anon-post");
  if (anonPostButton !== null) {
    anonPostButton.addEventListener("click", (evt) => {
      const title = document.getElementById("title").value;
      const content = document.getElementById("content").value;
      apiClient.createAnonPost(title, content);
    })
  }

  const loginButton = document.getElementById("login");
  const usernameField = document.getElementById("username");
  const passwordField = document.getElementById("password");
  if (loginButton !== null && usernameField !== null && passwordField !== null) {
    loginButton.addEventListener("click", (evt) => {
      apiClient.login(usernameField.value, passwordField.value);
    })
  }
}