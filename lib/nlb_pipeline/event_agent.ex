defmodule NlbPipeline.EventAgent do
	use GenEvent

	alias NlbPipeline.Event

	def handle_event({:model, _type, %{model: %Event{}} = changeset}) do
		NlbPipeline.StatusAgent.state
		|> Enum.filter(fn({{type, id}, status}) -> 
			if type == :support && status != :offline do
					NlbPipeline.Endpoint.broadcast "support:" <> id, "support:event:list", %{}
			end
		end)

		guardian_id = changeset.model.guardian_id
		NlbPipeline.Endpoint.broadcast "risk_management:" <> guardian_id, "risk_management:event:list", %{}
	end
end