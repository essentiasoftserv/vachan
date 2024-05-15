import VachanWeb.AuthOverrides

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
    plug VachanWeb.Plugs.RedirectIfAuthenticated
    plug VachanWeb.Plugs.LoadUser  # Add LoadUser plug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  pipeline :auth_check do
    plug VachanWeb.Plugs.RedirectIfAuthenticated  # Add RedirectIfAuthenticated plug
  end

  scope "/", VachanWeb do
    pipe_through [:browser, :auth_check]  # Use both browser and auth_check pipelines

    get "/demo", PageController, :home

    live "/", PrelaunchLive.Homepage
    live "/verify-email", VerifyEmailLive
    sign_in_route(
      register_path: "/register",
      reset_path: "/reset",
      overrides: [VachanWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
    )

    sign_out_route AuthController
    auth_routes_for Vachan.Accounts.User, to: AuthController
    reset_route []
  end

  scope "/", VachanWeb do
    pipe_through :browser  # Separate scope without auth_check

    ash_authentication_live_session :confirmed_user_required,
      on_mount: {VachanWeb.LiveUserAuth, :live_confirmed_user_required} do
      live "/profile", ProfileLive.Profile
    end

    ash_authentication_live_session :authentication_required,
      on_mount: {VachanWeb.LiveUserAuth, :live_profile_required} do
      live "/dashboard", DashLive

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

      live "/sender-profiles", SenderProfileLive.Index, :index
      live "/sender-profiles/new", SenderProfileLive.Index, :new
      live "/sender-profiles/:id/edit", SenderProfileLive.Index, :edit
      live "/sender-profiles/:id", SenderProfileLive.Show, :show
      live "/sender-profiles/:id/show/edit", SenderProfileLive.Show, :edit
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

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

