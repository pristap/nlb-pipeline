defmodule NlbPipeline.Faker do

	@event_type [:blocked, :bankruptcy, :almost_empty, :inflow, :outflow]
	@product_id [:foreign_account, :domestic_account, :deposit, :loan]
	@guardians ["ahsoka.tano", "asajj.ventress", "cad.bane", "sabine.wren", "satine.kryze", "hera.syndulla"]
	@support ["kex", "captain.flint", "jon.silver", "charles.vane", "jack.rackham"]

	def random_type do
		FakerElixir.Helper.pick @event_type
	end

	def random_product do
		FakerElixir.Helper.pick @product_id
	end

	def random_guardian do
		FakerElixir.Helper.pick @guardians
	end

	def guardian_ids do
		@guardians
	end

	def support_ids do
		@support
	end
end