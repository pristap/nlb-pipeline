defmodule NlbPipeline.Event do
	use NlbPipeline.Web, :model
	# use NlbPipeline.ModelLifecycle

	@derive {Poison.Encoder, only: [
		:id,
		:type,
		:product_id,
		:description,
		:name,
		:address,
		:account_no,
		:guardian_id,
		:sms_notification,
		:email_notification,
		:email,
		:phone,
		:processed,
		:contacted
	]}

	schema "events" do
		field :type, AtomType
		field :product_id, AtomType
		field :description, :string
		field :name, :string
		field :address, :string
		field :account_no, :string
		field :guardian_id, :string
		field :sms_notification, :boolean, default: true
		field :email_notification, :boolean, default: true
		field :email, :string
		field :phone, :string

		field :processed, :boolean, default: false
		field :contacted, :boolean, default: false

		timestamps()
	end

	@doc """
	Builds a changeset based on the `struct` and `params`.
	"""
	def changeset(struct, params \\ %{}) do
		struct
		|> cast(params, [:type, :product_id, :description, :name, :address, :account_no, :guardian_id, :email, :phone, :processed, :contacted])
		|> validate_required([:type, :product_id, :description, :name, :address, :account_no, :guardian_id, :email, :phone])
	end
end
