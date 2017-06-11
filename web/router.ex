defmodule NlbPipeline.Router do
	use NlbPipeline.Web, :router

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

	scope "/", NlbPipeline do
		pipe_through :browser # Use the default browser stack

		post "/", PageController, :index
		get "/", PageController, :index
		get "/logout", PageController, :logout
		get "/support/:support_id", PageController, :support
		get "/risk_management/:guardian_id", PageController, :risk_management
		get "/dashboard", PageController, :dashboard
		resources "/events", EventController
	end

	# Other scopes may use custom stacks.
	# scope "/api", NlbPipeline do
	#		pipe_through :api
	# end
end
