defmodule Server.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Server.Repo
  alias Server.Accounts.User
  require Logger

  @spec email_taken_error :: <<_::88>>
  def email_taken_error, do: "Email taken"
  def invalid_password_error, do: "Invalid password"
  def account_does_not_exist_error, do: "Account does not exist"

  def list_users do
    Repo.all(User)
  end

  def create_user(%{"email" => email, "password" => password}) do
    password_hash = Argon2.hash_pwd_salt(password)
    attrs = %{ email: email, password_hash: password_hash }

    case %User{} |> User.changeset(attrs) |> Repo.insert() do
      {:ok, user} -> {:ok, user}
      {:error, _} ->
        {:error, email_taken_error()}
    end
  end

  def authenticate(%{"email" => email, "password" => password}) do
    user = Repo.one(from u in User, where: u.email == ^email)
    case user do
      nil -> {:error, account_does_not_exist_error()}
      user ->
        case user |> Argon2.check_pass(password) do
          {:error, _} -> {:error, invalid_password_error()}
          {:ok, _} ->
            access_token = :crypto.strong_rand_bytes(32) |> Base.encode16 |> String.downcase
            User.changeset(user, %{access_token: access_token}) |> Repo.update
        end
    end
  end

  def authenticate(%{"user_id" => user_id, "access_token" => access_token}) do
    case Repo.one(from u in User, where: u.id == ^user_id and u.access_token == ^access_token) do
      nil -> :error
      _ -> :ok
    end
  end

  alias Server.Accounts.Character

  def list_characters(user_id) do
    Repo.all(from u in User, where: u.id == ^user_id)
  end


  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end
end
