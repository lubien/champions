defmodule Champions.Ranking.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :result, Ecto.Enum, values: [:winner_a, :winner_b, :draw]
    field :user_a_id, :integer
    field :user_b_id, :integer

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:result, :user_a_id, :user_b_id])
    |> validate_required([:result, :user_a_id, :user_b_id])
    |> foreign_key_constraint(:user_a_id)
    |> foreign_key_constraint(:user_b_id)
  end
end
