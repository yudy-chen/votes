defmodule VotesWeb.IssueController do
  use VotesWeb, :controller
  alias Votes.Repo
  alias Votes.User
  alias Votes.Issue

  def create(conn, params) do
    
    data = params["data"] |> Jason.decode!

    user_id = data["user_id"]
    description = data["description"]

    case Repo.get(User, user_id) do

      nil ->
        json conn, %{status: "User not found"}
      
      user ->
      
        #assume authorization and authentication are passed (user is allowed to create the issue)

        map_insert = %{
                        owner_id: user.id,
                        description: description
        }
        
        case %Issue{}
          |> Issue.changeset(map_insert)
          |> Repo.insert()
        do
          {:error, err} ->
            json conn, %{status: "Error insert"}
          _ -> 
            json conn, %{status: "OK"}
        end

      _ ->
        json conn, %{status: "Error find user"}

    end

  end

end
