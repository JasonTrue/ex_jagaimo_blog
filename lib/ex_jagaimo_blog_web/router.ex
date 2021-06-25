defmodule ExJagaimoBlogWeb.Router do
  use ExJagaimoBlogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_root_layout, {ExJagaimoBlogWeb.LayoutView, :root}
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExJagaimoBlogWeb do
    pipe_through :browser

    get "/", LandingController, :index
    resources "/posts", PostController
    resources "/blogs", BlogController

    scope "/archive" do
      get "/tags/*tags", PostController, :index, as: :tags_archive
      get "/", PostController, :index, as: :archive
      get "/:year", PostController, :index
      get "/:year/:month", PostController, :index
      get "/:year/:month/:day", PostController, :index
      get "/:year/:month/:day/:id", PostController, :show, as: :post_permalink
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExJagaimoBlogWeb do
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
      live_dashboard "/dashboard", metrics: ExJagaimoBlogWeb.Telemetry
    end
  end
end
