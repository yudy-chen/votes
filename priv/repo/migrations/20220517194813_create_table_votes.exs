defmodule Votes.Repo.Migrations.CreateTableVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all)
      add :issue_id, references(:issues, on_delete: :delete_all, on_update: :update_all)
      add :is_agree, :boolean

      timestamps()
    end

  end
end
