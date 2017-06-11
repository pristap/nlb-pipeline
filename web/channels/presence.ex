defmodule NlbPipeline.Presence do
	@moduledoc """
	Provides presence tracking to channels and processes.

	See the [`Phoenix.Presence`](http://hexdocs.pm/phoenix/Phoenix.Presence.html)
	docs for more details.

	## Usage

	Presences can be tracked in your channel after joining:

			defmodule NlbPipeline.MyChannel do
				use NlbPipeline.Web, :channel
				alias NlbPipeline.Presence

				def join("some:topic", _params, socket) do
					send(self, :after_join)
					{:ok, assign(socket, :user_id, ...)}
				end

				def handle_info(:after_join, socket) do
					{:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
						online_at: inspect(System.system_time(:seconds))
					})
					push socket, "presence_state", Presence.list(socket)
					{:noreply, socket}
				end
			end

	In the example above, `Presence.track` is used to register this
	channel's process as a presence for the socket's user ID, with
	a map of metadata. Next, the current presence list for
	the socket's topic is pushed to the client as a `"presence_state"` event.

	Finally, a diff of presence join and leave events will be sent to the
	client as they happen in real-time with the "presence_diff" event.
	See `Phoenix.Presence.list/2` for details on the presence datastructure.

	## Fetching Presence Information

	The `fetch/2` callback is triggered when using `list/1`
	and serves as a mechanism to fetch presence information a single time,
	before broadcasting the information to all channel subscribers.
	This prevents N query problems and gives you a single place to group
	isolated data fetching to extend presence metadata.

	The function receives a topic and map of presences and must return a
	map of data matching the Presence datastructure:

			%{"123" => %{metas: [%{status: "away", phx_ref: ...}],
				"456" => %{metas: [%{status: "online", phx_ref: ...}]}

	The `:metas` key must be kept, but you can extend the map of information
	to include any additional information. For example:

			def fetch(_topic, entries) do
				query =
					from u in User,
						where: u.id in ^Map.keys(entries),
						select: {u.id, u}

				users = query |> Repo.all |> Enum.into(%{})

				for {key, %{metas: metas}} <- entries, into: %{} do
					{key, %{metas: metas, user: users[key]}}
				end
			end

	The function above fetches all users from the database who
	have registered presences for the given topic. The fetched
	information is then extended with a `:user` key of the user's
	information, while maintaining the required `:metas` field from the
	original presence data.
	"""
	use Phoenix.Presence, otp_app: :nlb_pipeline,
		pubsub_server: NlbPipeline.PubSub

	# def fetch("control:lobby", entries) do
	# 	for {key, %{metas: metas}} <- entries, into: %{} do
	# 		new_metas = metas
	# 		|> Enum.map(fn(meta)-> 
	# 			put_in(meta[:status], NlbPipeline.StatusAgent.status({meta.type, meta.id}))
	# 		end)
	# 		{key, %{metas: new_metas}}
	# 	end
	# end

	alias NlbPipeline.StatusAgent

	def fetch("control:lobby", entries) do

		# for {{type, id}, status} <- StatusAgent.state, into: %{} do

		# 	key = "#{type}:#{id}"
		# 	presence_data = entries[key]

		# 	if presence_data == nil do
		# 		# if status != :offline do 
		# 		# 	case type do
		# 		# 		:risk_management ->
		# 		# 			StatusAgent.set_management_status(id, :offline)
		# 		# 		:support ->
		# 		# 			StatusAgent.set_support_status(id, :offline)
		# 		# 	end
		# 		# end
		# 		{key, %{metas: [], status: :offline, task_id: nil}}
		# 	else
		# 		task_id = NlbPipeline.TaskAgent.get(type, id)
		# 		{key, %{metas: presence_data.metas, status: status, task_id: task_id}}
		# 	end
		# end
		for {key, %{metas: metas}} <- entries, into: %{} do
			[type, id | _] = String.split(key, ":")
			type = type |> String.to_atom
			task_id = NlbPipeline.TaskAgent.get(type, id)
			status = NlbPipeline.StatusAgent.status {type, id}
			
			{key, %{metas: metas, status: status, task_id: task_id}}
		end
	end
end
