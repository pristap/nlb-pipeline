defmodule NlbPipeline.Repo.Migrations.AddContactedBoolean do
	use Ecto.Migration

	def change do
		alter table(:events) do
			add :contacted, :boolean, default: false, null: false
		end
	end
end
