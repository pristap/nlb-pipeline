defmodule NlbPipeline.UserSocket do
	use Phoenix.Socket

	## Channels
	channel "risk_management:*", NlbPipeline.RiskManagementChannel
	channel "support:*", NlbPipeline.SupportChannel
	channel "control:lobby", NlbPipeline.ControlChannel

	## Transports
	transport :websocket, Phoenix.Transports.WebSocket
	# transport :longpoll, Phoenix.Transports.LongPoll

	# Socket params are passed from the client and can
	# be used to verify and authenticate a user. After
	# verification, you can put default assigns into
	# the socket that will be set for all channels, ie
	#
	#			{:ok, assign(socket, :user_id, verified_user_id)}
	#
	# To deny connection, return `:error`.
	#
	# See `Phoenix.Token` documentation for examples in
	# performing token verification on connect.
	def connect(%{"user_id" => id, "user_type" => type} = params, socket) do
		IO.puts inspect params
		user_type = case type do
			"risk_management" -> :risk_management
			"support" -> :support
			"admin" -> :admin
		end
		updated_socket = socket
		|> assign(:user_id, id)
		|> assign(:user_type, user_type)

		{:ok, updated_socket}
	end

	# Socket id's are topics that allow you to identify all sockets for a given user:
	#
	#			def id(socket), do: "users_socket:#{socket.assigns.user_id}"
	#
	# Would allow you to broadcast a "disconnect" event and terminate
	# all active sockets and channels for a given user:
	#
	#			NlbPipeline.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
	#
	# Returning `nil` makes this socket anonymous.
	def id(socket), do: "user:#{socket.assigns.user_id}"
end
