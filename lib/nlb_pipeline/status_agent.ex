defmodule NlbPipeline.StatusAgent do

	require Logger

	@statuses [:online, :offline, :busy]

	def start_link do
		guardians = NlbPipeline.Faker.guardian_ids
		|> Enum.map(&({{:risk_management, &1}, :offline}))
		|> Map.new

		state = NlbPipeline.Faker.support_ids
		|> Enum.map(&({{:support, &1}, :offline}))
		|> Map.new
		|> Map.merge(guardians)
		
		Agent.start_link(fn -> state end, name: __MODULE__)
	end

	def state do
		Agent.get(__MODULE__, fn c -> c end )
	end

	def management_status(id) do
		status({:risk_management, id})
	end

	def support_status(id) do
		status({:support, id})
	end

	def set_management_status(id, status) do
		set_status {:risk_management, id}, status
	end

	def set_support_status(id, status) do
		set_status {:support, id}, status
	end

	defp set_status({role, user_id} = key, status)
	when is_atom(role) and is_bitstring(user_id) and is_atom(status) do
		Agent.update(__MODULE__, fn(state)->
			%{ state | key => status}
		end)
	end

	def status({role, user_id} = key)
	when is_atom(role) and is_bitstring(user_id) do
		Agent.get(__MODULE__, fn state -> 
			state[key]
		end)
	end
	# def add(message) do
	# 	{:ok, inserted_message} =  DemoPresence.Repo.insert message
	# 	Agent.update(__MODULE__, &Enum.concat(&1, [message]))
	# end
end