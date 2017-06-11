defmodule NlbPipeline.PageController do
	use NlbPipeline.Web, :controller

	def index(conn, %{"risk_management" => %{"guardian_id" => guardian_id}}) do
		conn
		# |> assign(:user_id, guardian_id)
		# |> assign(:type, :guardian)
		|> redirect(to: page_path(conn, :risk_management, guardian_id))
	end
	def index(conn, %{"support" => %{"support_id" => support_id}}) do
		conn
		# |> assign(:user_id, support_id)
		# |> assign(:type, :support)
		|> redirect(to: page_path(conn, :support, support_id))
	end
	def index(conn, _params) do
		conn
		|> render("index.html", guardian_ids: NlbPipeline.Faker.guardian_ids, support_ids: NlbPipeline.Faker.support_ids)
	end

	def logout(conn, _params) do
		conn
		# |> configure_session(drop: true)
		|> redirect(to: page_path(conn, :index))
	end

	def support(conn, _params) do
		# cond do
		# 	conn.assigns[:user_id] == params ->
				
		# end
		render conn, "support.html"
	end

	def risk_management(conn, _params) do
		# redirect conn, to: page_path(conn, :risk_management, guardian_id)
		render conn, "risk_management.html"
	end

	def dashboard(conn, _params) do
		render conn, "dashboard.html"
	end
end
