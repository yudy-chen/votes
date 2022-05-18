defmodule Votes.Repo.Migrations.AddIsAgree do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      add :is_agree, :boolean
    end

  end
end
