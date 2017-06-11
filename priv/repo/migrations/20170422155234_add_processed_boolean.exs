defmodule NlbPipeline.Repo.Migrations.AddProcessedBoolean do
	use Ecto.Migration

	def change do
		alter table(:events) do
			add :processed, :boolean, default: false, null: false
		end
	end
end
