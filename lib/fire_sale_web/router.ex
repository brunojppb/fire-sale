defmodule FireSaleWeb.Router do
  use FireSaleWeb, :router

  import Phoenix.LiveDashboard.Router
  import FireSaleWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FireSaleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FireSaleWeb do
    pipe_through :browser

    get "/pi/:filename", ProductImageController, :show
    get "/r/:token", ReservationConfirmationController, :show

    live_session :default, on_mount: [{FireSaleWeb.UserAuth, :mount_current_user}] do
      live "/", HomeLive, :index
      live "/p/:id", ProductLive.ProductListing, :index
      live "/p/:id/r", ProductLive.ProductListing, :reserve
      live "/r/s/thx", ProductLive.PostReservation, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", FireSaleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:fire_sale, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/ops", FireSaleWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{FireSaleWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/ops", FireSaleWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_dashboard "/dashboard",
      metrics: FireSaleWeb.Telemetry,
      ecto_repos: [FireSale.Repo],
      ecto_psql_extras_options: [long_running_queries: [threshold: "200 milliseconds"]]

    live_session :require_authenticated_user,
      on_mount: [{FireSaleWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/jobs", JobsLive, :index

      live "/products", ProductLive.Index, :index
      live "/products/new", ProductLive.Index, :new
      live "/products/:id/edit", ProductLive.Index, :edit
      live "/products/:id/images", ProductLive.Index, :add_image

      live "/products/:id", ProductLive.Show, :show
      live "/products/:id/show/edit", ProductLive.Show, :edit
    end
  end

  scope "/ops", FireSaleWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{FireSaleWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
