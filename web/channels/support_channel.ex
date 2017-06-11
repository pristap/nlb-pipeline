defmodule NlbPipeline.SupportChannel do
	use NlbPipeline.Web, :channel
	require Logger
	alias NlbPipeline.StatusAgent
	alias NlbPipeline.TaskAgent
	alias NlbPipeline.EventHelper

	intercept ["support:event:list"]

	def join("support:lobby", %{"user_id" => user_id} = _payload, socket) do
		updated_socket = socket
		|> assign(:user_id, user_id)

		send self(), :after_join
		{:ok, updated_socket}
	end
	
	def handle_info(:after_join, socket) do
		Logger.debug "Joined user " <> inspect(socket.assigns.user_id)

		push socket, "support:task:list", %{
			tasks: EventHelper.support_list
		}

		action = case StatusAgent.support_status(socket.assigns.user_id) do
			:online -> "finish"
			:busy -> "start"
			_ -> ""
		end
		push socket, "support:task:" <> action, %{
			user_id: socket.assigns.user_id,
			task_id: TaskAgent.get(:support, socket.assigns.user_id)
		}

		{:noreply, socket}
	end

	def handle_in("support:event:list", _payload, socket) do
		push socket, "support:task:list", %{
			tasks: EventHelper.support_list
		}
		{:noreply, socket}
	end

	def handle_in("support:task:" <> action, %{"task" => task_id}, socket) do
		case action do
			"start" ->
				StatusAgent.set_support_status socket.assigns.user_id, :busy
				TaskAgent.set(:support, socket.assigns.user_id, task_id)
			"finish" ->
				StatusAgent.set_support_status socket.assigns.user_id, :online
				EventHelper.contacted(task_id)
				TaskAgent.set(:support, socket.assigns.user_id, nil)
				broadcast! socket, "support:task:list", %{
					tasks: EventHelper.support_list
				}
		end
		
		broadcast! socket, "support:task:" <> action, %{
			user_id: socket.assigns.user_id,
			task_id: task_id
		}

		NlbPipeline.Endpoint.broadcast! "control:lobby", "update_presence", %{}
		{:noreply, socket}
	end
end
