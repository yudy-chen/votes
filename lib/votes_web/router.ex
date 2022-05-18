defmodule VotesWeb.Router do
  use VotesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VotesWeb do
    pipe_through :browser

    get "/", PageController, :index

  end

  scope "/api", VotesWeb do

    pipe_through :api

    put "/issues/create", IssueController, :create
    put "/votes/update", VoteController, :update
    
    delete "/votes/delete", VoteController, :delete
    
    get "/votes/count", VoteController, :count_all
    get "/votes/count/:id", VoteController, :count_single

  end

  # Other scopes may use custom stacks.
  # scope "/api", VotesWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: VotesWeb.Telemetry
    end
  end
end
