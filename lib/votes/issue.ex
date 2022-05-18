defmodule Votes.Issue do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votes.Vote

  schema "issues" do
    field :description, :string
    belongs_to :owner, Votes.User, on_replace: :delete
    has_many :vote, Votes.Vote

    timestamps()
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:description, :owner_id])
    |> validate_required([:description, :owner_id])
  end
end
