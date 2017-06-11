defmodule NlbPipeline.TaskAgent do

	require Logger

	def start_link do

		Agent.start_link(fn -> %{} end, name: __MODULE__)
	end

	def state do
		Agent.get(__MODULE__, fn c -> c end )
	end

	def get(user_role, user_id)
	when is_atom(user_role) and is_bitstring(user_id) do
		Agent.get(__MODULE__, fn state -> 
			state[{user_role, user_id}]
		end)
	end

	def set(user_role, user_id, task_id)
	when is_atom(user_role) and is_bitstring(user_id) do
		Agent.update(__MODULE__, fn(state)->
			state |> Map.put({user_role, user_id}, task_id)
		end)
	end
end