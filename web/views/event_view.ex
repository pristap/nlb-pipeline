defmodule NlbPipeline.EventView do
	use NlbPipeline.Web, :view

	def guardian_name(guardian_id) do
		guardian_id
		|> String.split(".")
		|> Enum.map(&String.capitalize/1)
		|> Enum.join(" ")
	end
end
