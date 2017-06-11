defmodule NlbPipeline.ModelLifecycle do
	alias NlbPipeline.Trigger

	defmacro __using__(_) do
		quote do
			import unquote(__MODULE__)

			after_insert :broadcast_trigger, [:insert]
			after_update :broadcast_trigger, [:update]
			after_delete :broadcast_trigger, [:delete]
		end
	end

	# Broadcasts triggers in this format:
	# {:model, :update, changeset}
	def broadcast_trigger(changeset, type) do
		Trigger.broadcast({:model, type, changeset})
		changeset
	end
end