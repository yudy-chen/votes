# Votes

This is the example of how to query the "count" of a field from other table on Elixir Ecto

'''
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

'''

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
