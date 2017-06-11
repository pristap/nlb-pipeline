defmodule NlbPipeline.Repo.Migrations.AddPhoneAndMailFields do
	use Ecto.Migration

	def change do
		alter table(:events) do
			modify :email, :text
			add :phone, :text
			remove :sms
			add :sms_notification, :boolean, default: false, null: false
			add :email_notification, :boolean, default: false, null: false
		end
	end
end
