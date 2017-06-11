defmodule NlbPipeline.RiskManagementControllerTest do
	use NlbPipeline.ConnCase

	alias NlbPipeline.RiskManagement
	@valid_attrs %{}
	@invalid_attrs %{}

	test "lists all entries on index", %{conn: conn} do
		conn = get conn, risk_management_path(conn, :index)
		assert html_response(conn, 200) =~ "Listing risk_management"
	end

	test "renders form for new resources", %{conn: conn} do
		conn = get conn, risk_management_path(conn, :new)
		assert html_response(conn, 200) =~ "New risk management"
	end

	test "creates resource and redirects when data is valid", %{conn: conn} do
		conn = post conn, risk_management_path(conn, :create), risk_management: @valid_attrs
		assert redirected_to(conn) == risk_management_path(conn, :index)
		assert Repo.get_by(RiskManagement, @valid_attrs)
	end

	test "does not create resource and renders errors when data is invalid", %{conn: conn} do
		conn = post conn, risk_management_path(conn, :create), risk_management: @invalid_attrs
		assert html_response(conn, 200) =~ "New risk management"
	end

	test "shows chosen resource", %{conn: conn} do
		risk_management = Repo.insert! %RiskManagement{}
		conn = get conn, risk_management_path(conn, :show, risk_management)
		assert html_response(conn, 200) =~ "Show risk management"
	end

	test "renders page not found when id is nonexistent", %{conn: conn} do
		assert_error_sent 404, fn ->
			get conn, risk_management_path(conn, :show, -1)
		end
	end

	test "renders form for editing chosen resource", %{conn: conn} do
		risk_management = Repo.insert! %RiskManagement{}
		conn = get conn, risk_management_path(conn, :edit, risk_management)
		assert html_response(conn, 200) =~ "Edit risk management"
	end

	test "updates chosen resource and redirects when data is valid", %{conn: conn} do
		risk_management = Repo.insert! %RiskManagement{}
		conn = put conn, risk_management_path(conn, :update, risk_management), risk_management: @valid_attrs
		assert redirected_to(conn) == risk_management_path(conn, :show, risk_management)
		assert Repo.get_by(RiskManagement, @valid_attrs)
	end

	test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
		risk_management = Repo.insert! %RiskManagement{}
		conn = put conn, risk_management_path(conn, :update, risk_management), risk_management: @invalid_attrs
		assert html_response(conn, 200) =~ "Edit risk management"
	end

	test "deletes chosen resource", %{conn: conn} do
		risk_management = Repo.insert! %RiskManagement{}
		conn = delete conn, risk_management_path(conn, :delete, risk_management)
		assert redirected_to(conn) == risk_management_path(conn, :index)
		refute Repo.get(RiskManagement, risk_management.id)
	end
end
