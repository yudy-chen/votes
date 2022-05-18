defmodule Votes.Repo.Migrations.AddM2M do
  use Ecto.Migration

  def change do
    create table(:votes, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all)
      add :issue_id, references(:issues, on_delete: :delete_all, on_update: :update_all)

      timestamps()
    end

  end
end
