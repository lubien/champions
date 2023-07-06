defmodule Champions.Ranking do
  @moduledoc """
  The Ranking context.
  """

  import Ecto.Query, warn: false
  alias Champions.Repo

  alias Champions.Accounts
  alias Champions.Ranking.Match
  alias Champions.Accounts.User

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_points(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_points(%User{} = user, attrs \\ %{}) do
    User.points_changeset(user, attrs)
  end

  @doc """
  Updates the current number of points of a user

  ## Examples

      iex> update_user_points(user, 10)
      {:ok, %User{points: 10}}

  """
  def update_user_points(%User{} = user, points) do
    user
    |> change_user_points(%{"points" => points})
    |> Repo.update()
  end

  @doc """
  Adds 3 points to the winning user

  ## Examples

      iex> concede_loss_to(%User{points: 0})
      {:ok, %User{points: 3}}

  """
  def concede_loss_to(loser, winner) do
    {:ok, _match} = create_match(%{
      user_a_id: loser.id,
      user_b_id: winner.id,
      result: :winner_b
    })
    increment_user_points(winner, 3)
  end

  @doc """
  Adds 1 point to each user

  ## Examples

      iex> declare_draw_match(%User{points: 0}, %User{points: 0})
      {:ok, %User{points: 1}, %User{points: 1}}

  """
  def declare_draw_match(user_a, user_b) do
    {:ok, _match} = create_match(%{
      user_a_id: user_a.id,
      user_b_id: user_b.id,
      result: :draw
    })
    {:ok, updated_user_a} = increment_user_points(user_a, 1)
    {:ok, updated_user_b} = increment_user_points(user_b, 1)
    {:ok, updated_user_a, updated_user_b}
  end

  @doc """
  Increments `amount` points to the user and returns its updated model

  ## Examples

      iex> increment_user_points(%User{points: 0}, 1)
      {:ok, %User{points: 1}}

  """
  def increment_user_points(user, amount) do
    {1, nil} =
      User
      |> where(id: ^user.id)
      |> Repo.update_all(inc: [points: amount])

    {:ok, Accounts.get_user!(user.id)}
  end
end
