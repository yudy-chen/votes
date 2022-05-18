defmodule Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    belongs_to :user, Votes.User, foreign_key: :user_id, on_replace: :delete
    belongs_to :issue, Votes.Issue, foreign_key: :issue_id, on_replace: :delete
    field :is_agree, :boolean
    
    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:user_id, :issue_id, :is_agree])
    |> validate_required([:user_id, :issue_id, :is_agree])
  end

end
