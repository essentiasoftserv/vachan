defmodule VachanWeb.Router do
  use VachanWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VachanWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", VachanWeb do
    pipe_through :browser

    get "/demo", PageController, :home

    get "/", PageController, :home
    # Leave out `register_path` and `reset_path` if you don't want to support
    # user registration and/or password resets respectively.
    sign_in_route(register_path: "/register", reset_path: "/reset")

    sign_out_route AuthController
    auth_routes_for Vachan.Accounts.User, to: AuthController
    reset_route []

    ash_authentication_live_session :authentication_required,
      on_mount: {VachanWeb.LiveUserAuth, :live_user_required} do
      live "/dashboard", DashLive

      # live "people", Crm.People
      live "/people", PersonLive.Index, :index
      live "/people/new", PersonLive.Index, :new
      live "/people/:id/edit", PersonLive.Index, :edit

      live "/people/:id", PersonLive.Show, :show
      live "/people/:id/show/edit", PersonLive.Show, :edit
      live "/people/:id/lists", PersonLive.AddToList

      live "/lists", ListLive.Index, :index
      live "/lists/new", ListLive.Index, :new
      live "/lists/:id/edit", ListLive.Index, :edit

      live "/lists/:id", ListLive.Show, :show
      live "/lists/:id/show/edit", ListLive.Show, :edit

      live "/campaigns", CampaignLive.Index, :index
      live "/campaigns/new", CampaignLive.Edit, :new
      live "/campaigns/:id/edit", CampaignLive.Edit, :edit
      live "/campaigns/:id/", CampaignLive.Show, :show
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", VachanWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:vachan, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: VachanWeb.Telemetry,
        additional_pages: [
          oban: Oban.LiveDashboard
        ]

      # live_dashboard "/dashboard", metrics: VachanWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
