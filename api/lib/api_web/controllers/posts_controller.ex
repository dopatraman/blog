defmodule ApiWeb.PostsController do
  use ApiWeb, :controller

  # GET /posts
  def index(conn, _params), do: :ok

  # GET /posts/:id/edit
  def edit(conn, _params), do: :ok

  # GET /posts/new
  def new(conn, _params), do: :ok

  # GET /users/:id
  def show(conn, _params), do: :ok

  # POST /users
  def create(conn, _params), do: :ok

  # PATCH/PUT /users/:id
  def update(conn, _params), do: :ok

  # DELETE /users/:id
  def delete(conn, _params), do: :ok
end