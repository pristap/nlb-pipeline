defmodule NlbPipeline.EventTest do
	use NlbPipeline.ModelCase

	alias NlbPipeline.Event

	@valid_attrs %{account_no: "some content", address: "some content", description: "some content", email: true, guardian_id: "some content", name: "some content", product_id: "some content", sms: true, type: "some content"}
	@invalid_attrs %{}

	test "changeset with valid attributes" do
		changeset = Event.changeset(%Event{}, @valid_attrs)
		assert changeset.valid?
	end

	test "changeset with invalid attributes" do
		changeset = Event.changeset(%Event{}, @invalid_attrs)
		refute changeset.valid?
	end
end
