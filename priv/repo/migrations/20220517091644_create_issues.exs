defmodule Votes.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :description, :string

      timestamps()
    end

  end
end
