defmodule Votes.Repo.Migrations.AddIssueUserID1 do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      add :owner_id, references(:users, on_delete: :delete_all)
    end
  end
end
