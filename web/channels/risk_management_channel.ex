defmodule NlbPipeline.RiskManagementChannel do
	use NlbPipeline.Web, :channel
	require Logger
	alias NlbPipeline.StatusAgent
	alias NlbPipeline.TaskAgent
	alias NlbPipeline.EventHelper

	intercept ["risk_management:event:list"]

	def join("risk_management:" <> user_id, _payload, socket) do
		updated_socket = socket
		|> assign(:user_id, user_id)
		
		send self(), :after_join
		{:ok, updated_socket}
	end

	def handle_info(:after_join, socket) do
		Logger.debug "Joined user " <> inspect(socket.assigns.user_id)

		push socket, "risk_management:task:list", %{
			tasks: EventHelper.management_list(socket.assigns.user_id)
		}

		action = case StatusAgent.management_status(socket.assigns.user_id) do
			:online -> "finish"
			:busy -> "start"
			_ -> ""
		end
		push socket, "risk_management:task:" <> action, %{}

		{:noreply, socket}
	end

	def handle_in("risk_menagement:event:list", _payload, socket) do
		push socket, "risk_management:task:list", %{
			tasks: EventHelper.management_list(socket.assigns.user_id)
		}
		{:noreply, socket}
	end

	def handle_in("risk_management:task:" <> action, %{"task" => task_id}, socket) do
		case action do
			"start" ->
				StatusAgent.set_management_status socket.assigns.user_id, :busy
				TaskAgent.set(:risk_management, socket.assigns.user_id, task_id)
			"finish" ->
				StatusAgent.set_management_status socket.assigns.user_id, :online
				EventHelper.processed(task_id)
				TaskAgent.set(:risk_management, socket.assigns.user_id, nil)
				broadcast! socket, "risk_management:task:list", %{
					tasks: EventHelper.management_list(socket.assigns.user_id)
				}
		end
		broadcast! socket, "risk_management:task:" <> action, %{}
		NlbPipeline.Endpoint.broadcast! "control:lobby", "update_presence", %{}
		{:noreply, socket}
	end
end
