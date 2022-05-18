defmodule Votes.Repo.Migrations.AddIssueUserID do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
