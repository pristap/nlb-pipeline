# Script for populating the database. You can run it as:
#
#			mix run priv/repo/seeds.exs

Enum.each(1..1_000, fn(i) -> 
	random = NlbPipeline.Util.random_string(4)
	NlbPipeline.Repo.insert!(%NlbPipeline.Event{
		type: NlbPipeline.Faker.random_type,
		product_id: NlbPipeline.Faker.random_product,
		account_no: FakerElixir.Bank.credit_card_number,
		guardian_id: NlbPipeline.Faker.random_guardian,
		description: 
			FakerElixir.Number.between(1..4)
			|> FakerElixir.Lorem.sentences,
		name: FakerElixir.Name.name,
		address: FakerElixir.Address.street_address,
		phone: FakerElixir.Phone.cell,
		email: FakerElixir.Internet.email,
		sms_notification: FakerElixir.Boolean.boolean(0.5),
		email_notification: FakerElixir.Boolean.boolean(0.5)
	})
end)