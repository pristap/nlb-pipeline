defmodule NlbPipeline.Util do
	
	@chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")
	@numbers "0123456789" |> String.split("")

	def random_chars(length) do
		random_sequence :chars, length
	end

	def random_number(length) do
		random_sequence :number, length
	end

	def random_string(length) do
		:crypto.strong_rand_bytes(length)
		|> Base.url_encode64
		|> binary_part(0, length)
	end

	defp random_sequence(type, length) do
		sequence = case type do
			:number -> @numbers
			:chars -> @chars
		end

		Enum.reduce((1..length), [], fn (_i, acc) ->
			[Enum.random(sequence) | acc]
		end) |> Enum.join("")
	end
end