/**
 * ApiClient.js
 * ============
 * Blog api client
 */
export default function ApiClient() {
  this.login = function(username, password) {
    return fetch("/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        user: {
          username: username,
          password: password
        }
      })
    }).then((res) => {
      const header = res.headers.get("authorization");
      const tokens = header.split("Bearer ");
      if (tokens.length === 2) {
        localStorage.setItem("header", header);
        document.cookie = "guardian_default_token=" + tokens[1];
        location.assign("/create");
      }
    });
  }

  this.createPost = function(title, content) {
    const header = localStorage.getItem("header");
    if (header === null) {
      return console.log("Sorry, couldn't create your post.");
    }
    return fetch("/posts", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": header
      },
      body: JSON.stringify({
        title: title,
        content: content,
        is_private: false
      })
    }).then(console.log);
  }

  this.createAnonPost = function(title, content) {
    console.log(title, content)
    debugger;
    return fetch("/anon", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        title: title,
        content: content
      })
    }).then(console.log);
  }
}