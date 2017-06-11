defmodule NlbPipeline.ControlChannel do
	use NlbPipeline.Web, :channel

	alias NlbPipeline.StatusAgent
	alias NlbPipeline.Presence

	require Logger

	intercept ["update_presence"]

	def join("control:lobby", _payload, socket) do
		send self(), :after_join
		{:ok, socket}
	end

	def handle_out("update_presence", _payload, socket) do
		push socket, "presence_state", Presence.list(socket)
		{:noreply, socket}
	end

	def handle_info(:after_join, socket) do

		id = socket.assigns.user_id

		case socket.assigns.user_type do
			:risk_management ->
				if StatusAgent.management_status(socket.assigns.user_id) == :offline, 
				do: StatusAgent.set_management_status(socket.assigns.user_id, :online)
				Presence.track(socket, "risk_management:" <> id, %{
					id: id,
					type: :risk_management,
					device: "browser",
					online_at: inspect(:os.timestamp())
				})
			:support ->
				if StatusAgent.support_status(socket.assigns.user_id) == :offline, 
				do: StatusAgent.set_support_status(socket.assigns.user_id, :online)
				Presence.track(socket, "support:" <> id, %{
					id: id,
					type: :support,
					device: "browser",
					online_at: inspect(:os.timestamp())
				})
			:admin ->
				:ok
		end

		Logger.debug "Users online: "
		Logger.debug inspect(Presence.list(socket))

		users = NlbPipeline.StatusAgent.state
		|> Map.keys
		|> Enum.map(fn({type, id}) ->
			"#{Atom.to_string(type)}:#{id}"
		end)
		push socket, "users", %{users: users}

		push socket, "presence_state", Presence.list(socket)
		{:noreply, socket}
	end
end
