defmodule NlbPipeline.SupportControllerTest do
	use NlbPipeline.ConnCase

	alias NlbPipeline.Support
	@valid_attrs %{}
	@invalid_attrs %{}

	test "lists all entries on index", %{conn: conn} do
		conn = get conn, support_path(conn, :index)
		assert html_response(conn, 200) =~ "Listing support"
	end

	test "renders form for new resources", %{conn: conn} do
		conn = get conn, support_path(conn, :new)
		assert html_response(conn, 200) =~ "New support"
	end

	test "creates resource and redirects when data is valid", %{conn: conn} do
		conn = post conn, support_path(conn, :create), support: @valid_attrs
		assert redirected_to(conn) == support_path(conn, :index)
		assert Repo.get_by(Support, @valid_attrs)
	end

	test "does not create resource and renders errors when data is invalid", %{conn: conn} do
		conn = post conn, support_path(conn, :create), support: @invalid_attrs
		assert html_response(conn, 200) =~ "New support"
	end

	test "shows chosen resource", %{conn: conn} do
		support = Repo.insert! %Support{}
		conn = get conn, support_path(conn, :show, support)
		assert html_response(conn, 200) =~ "Show support"
	end

	test "renders page not found when id is nonexistent", %{conn: conn} do
		assert_error_sent 404, fn ->
			get conn, support_path(conn, :show, -1)
		end
	end

	test "renders form for editing chosen resource", %{conn: conn} do
		support = Repo.insert! %Support{}
		conn = get conn, support_path(conn, :edit, support)
		assert html_response(conn, 200) =~ "Edit support"
	end

	test "updates chosen resource and redirects when data is valid", %{conn: conn} do
		support = Repo.insert! %Support{}
		conn = put conn, support_path(conn, :update, support), support: @valid_attrs
		assert redirected_to(conn) == support_path(conn, :show, support)
		assert Repo.get_by(Support, @valid_attrs)
	end

	test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
		support = Repo.insert! %Support{}
		conn = put conn, support_path(conn, :update, support), support: @invalid_attrs
		assert html_response(conn, 200) =~ "Edit support"
	end

	test "deletes chosen resource", %{conn: conn} do
		support = Repo.insert! %Support{}
		conn = delete conn, support_path(conn, :delete, support)
		assert redirected_to(conn) == support_path(conn, :index)
		refute Repo.get(Support, support.id)
	end
end
