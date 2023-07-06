defmodule Champions.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :result, :string
      add :user_a_id, references(:users, on_delete: :nothing)
      add :user_b_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:matches, [:user_a_id])
    create index(:matches, [:user_b_id])
  end
end
