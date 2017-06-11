defmodule NlbPipeline.Repo.Migrations.CreateEvent do
	use Ecto.Migration

	def change do
		create table(:events) do
			add :type, :string
			add :product_id, :string
			add :description, :string
			add :name, :string
			add :address, :string
			add :account_no, :string
			add :guardian_id, :string
			add :sms, :boolean, default: false, null: false
			add :email, :boolean, default: false, null: false

			timestamps()
		end

	end
end
