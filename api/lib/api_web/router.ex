defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :from_verification do
    plug Api.Auth.FromVerificationPipeline
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
    get "/login", AuthController, :index
  end

  scope "/", ApiWeb do
    pipe_through [:api]
    post "/login", AuthController, :login
    post "/logout", AuthController, :logout
  end

  scope "/posts", ApiWeb do
    pipe_through [:api, :from_verification, :protected]
    resources "/", PostsController, only: [:create]
  end

  scope "/users/:author_id" do
    scope "/posts", ApiWeb do
      pipe_through [:api]
      get "/latest", PostsController, :latest
      resources "/", PostsController, only: [:index, :show]
    end
  end
end
