defmodule VotesWeb.VoteController do
  use VotesWeb, :controller
  alias Votes.Repo
  alias Votes.User
  alias Votes.Issue
  alias Votes.Vote
  import Ecto.Query, only: [from: 2]

  def update(conn, params) do

    #assume authorization and authentication are passed

    data = params["data"] |> Jason.decode!

    user_id = data["user_id"]
    issue_id = data["issue_id"]
    is_agree = data["is_agree"]

    user  = Repo.get(User, user_id)
    issue = Repo.get(Issue, issue_id)

    if is_nil(user) or is_nil(issue) do

      json conn, %{status: "Error. User or issue not found"}

    else

      vote = Repo.get_by(Vote, [user_id: user_id, issue_id: issue_id]) |> Repo.preload([:user])
      
      res = if not is_nil(vote) do

        Ecto.Changeset.change(vote)
          |> Ecto.Changeset.put_assoc(:user, user)
          |> Repo.update!()
        
        vote
          |> Vote.changeset(%{is_agree: is_agree}) |> Repo.update()
      else
        
        changeset = %{user_id: user_id, issue_id: issue_id, is_agree: is_agree}

        %Vote{}
          |> Vote.changeset(changeset) |> Repo.insert()
      end
      
      case res do
        {:ok, _} -> json conn, %{status: "OK"}
        _ -> json conn, %{status: "Error"}
      end
    end
    
  end

  def count_all(conn, _params) do
    
    votes_count = Repo.all(from issue in Issue,
              as: :issue,
              left_lateral_join: vote in subquery(from v in Vote,
                where: [issue_id:  parent_as(:issue).id],
                group_by: [v.issue_id, v.is_agree],
                select: %{
                  count: count("*"),
                  is_agree: v.is_agree
                }
              ),
              select: %{
                issue_id: issue.id,
                count: vote.count,
                is_agree: vote.is_agree,
                issue_description: issue.description
              }
    )
      |> map_count_result()

    json conn, %{status: "OK", count: votes_count}

  end

  def count_single(conn, %{"id" => id}) do
    
    vote_count = Repo.all(from issue in Issue,
              as: :issue,
              where: issue.id == ^id,
              inner_lateral_join: vote in subquery(from v in Vote,
                where: [issue_id:  parent_as(:issue).id],
                group_by: [v.issue_id, v.is_agree],
                select: %{
                  count: count("*"),
                  is_agree: v.is_agree
                }
              ),
              select: %{
                issue_id: issue.id,
                count: vote.count,
                is_agree: vote.is_agree,
                issue_description: issue.description
              }
    )
      |> map_count_result()

    json conn, %{status: "OK", count: vote_count}

  end

  def delete(conn, params) do
    
    #assume authorization and authentication are passed. The owner of issue is the one that sending the request

    data = params["data"] |> Jason.decode!

    user_id = data["user_id"]
    issue_id = data["issue_id"]

    case Repo.get_by(Vote, [user_id: user_id, issue_id: issue_id]) do

      nil -> json conn, %{status: "OK"} #vote not found or assume repeated request (has been deleted before). No harm to return OK
      vote ->

        case vote |> Repo.delete() do
          {:ok, _} -> json conn, %{status: "OK"}
          _ -> json conn, %{status: "Error deleting vote"}
        end

      _ -> json conn, %{status: "Error getting vote for delete"}

    end

  end

  def map_count_result(list_count) do

    Enum.reduce(list_count, %{}, fn (x, new_map) ->
      
      map_key = Integer.to_string(x.issue_id)

      if Map.has_key?(new_map, map_key) == false do

        local_map = %{
          issue_description: x.issue_description,
          is_agree_count: (if x.is_agree == true, do: x.count, else: 0),
          is_disagree_count: (if x.is_agree == false, do: x.count, else: 0)
        }

        Map.put(new_map, map_key, local_map)

      else
        
        existing_value = new_map[map_key]

        local_map = %{
          issue_description: x.issue_description,
          is_agree_count: (if x.is_agree == true, do: x.count, else: existing_value.is_agree_count),
          is_disagree_count: (if x.is_agree == false, do: x.count, else: existing_value.is_disagree_count)
        }

        Map.update!(new_map, map_key, fn x -> local_map end)
      end

    end)

  end

end
