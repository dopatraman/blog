defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :verify_auth_header do
    plug Api.Auth.VerifyAuthHeaderPipeline
  end

  pipeline :verify_auth_cookie do
    plug Api.Auth.VerifyAuthCookiePipeline
  end

  pipeline :protected do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ApiWeb do
    pipe_through [:browser]
    resources "/", PageController, only: [:index]
    get "/login", PageController, :login
  end

  scope "/", ApiWeb do
    pipe_through [:browser, :verify_auth_cookie, :protected]
    get "/create", PageController, :create_post
  end

  scope "/", ApiWeb do
    pipe_through [:api]
    post "/login", AuthController, :login
    post "/logout", AuthController, :logout
  end

  scope "/posts", ApiWeb do
    pipe_through [:api, :verify_auth_header, :protected]
    resources "/", PostsController, only: [:create]
  end

  scope "/users/:author_id", ApiWeb do
    pipe_through [:browser]
    get "/latest", PageController, :latest
  end

  scope "/users/:author_id", ApiWeb do
    scope "/posts" do
      pipe_through [:api]
      resources "/", PostsController, only: [:index, :show]
    end
  end
end
