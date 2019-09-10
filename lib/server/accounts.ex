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

  def create_user(email, password) do
    password_hash = Argon2.hash_pwd_salt(password)
    attrs = %{ email: email, password_hash: password_hash }

    case %User{} |> User.changeset(attrs) |> Repo.insert() do
      {:ok, user} -> {:ok, user}
      {:error, _} ->
        {:error, email_taken_error()}
    end
  end

  def authenticate(email, password) do
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

  alias Server.Accounts.Character

  @doc """
  Returns the list of characters.

  ## Examples

      iex> list_characters()
      [%Character{}, ...]

  """
  def list_characters(_user_id) do
    Repo.all(Character)
  end

  @doc """
  Gets a single character.

  Raises `Ecto.NoResultsError` if the Character does not exist.

  ## Examples

      iex> get_character!(123)
      %Character{}

      iex> get_character!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character!(id), do: Repo.get!(Character, id)

  @doc """
  Creates a character.

  ## Examples

      iex> create_character(%{field: value})
      {:ok, %Character{}}

      iex> create_character(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a character.

  ## Examples

      iex> update_character(character, %{field: new_value})
      {:ok, %Character{}}

      iex> update_character(character, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Character.

  ## Examples

      iex> delete_character(character)
      {:ok, %Character{}}

      iex> delete_character(character)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character changes.

  ## Examples

      iex> change_character(character)
      %Ecto.Changeset{source: %Character{}}

  """
  def change_character(%Character{} = character) do
    Character.changeset(character, %{})
  end
end
