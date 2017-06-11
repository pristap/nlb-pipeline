defmodule NlbPipeline.EventHelper do
	import Ecto.Query
	alias NlbPipeline.Repo
	alias NlbPipeline.Event

	def management_list(user_id) do
		Event
		|> where(processed: false)
		|> where(guardian_id: ^user_id)
		|> limit(100)
		|> Repo.all
	end

	def support_list do
		Event
		|> where(contacted: false)
		|> limit(100)
		|> Repo.all
	end

	def processed(task_id) do
			update_event(task_id, %{processed: true})
	end

	def contacted(task_id) do
		update_event(task_id, %{contacted: true})
	end

	def update_event(task_id, updates) when is_map(updates) do
		Event
		|> Repo.get(task_id)
		|> Event.changeset(updates)
		|> Repo.update!
	end

end