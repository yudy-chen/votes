defmodule VotesWeb.PageController do
  use VotesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
