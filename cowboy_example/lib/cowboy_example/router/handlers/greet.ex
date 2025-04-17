defmodule CowboyExample.Router.Handlers.Greet do
  @moduledoc """
  This module defines the handler for "/greet/:who" route.
  """

  require Logger

  @doc """
  This function handles the "/greet/:who", logs the requests and
  responds with Hello `who` as the body
  """
  def init(req0, state) do
    Logger.info("Received request: #{inspect req0}")
    who = :cowboy_req.binding(:who, req0)
    req1 =
      :cowboy_req.reply(
        200,
        %{"content-type" => "text/html"},
        "Hello #{who}\n",
        req0
      )
    {:ok, req1, state}
  end
end
