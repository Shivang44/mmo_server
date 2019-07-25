defmodule ServerWeb.UserView do
  use ServerWeb, :view
  alias ServerWeb.UserView
  require Logger

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      password_hash: user.password_hash,
      access_token: user.access_token}
  end

  def render("data.json", %{data: data}) do
    %{data: data}
  end
end
