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
    }).then((res) => res.headers.get("authorization"));
  }
}