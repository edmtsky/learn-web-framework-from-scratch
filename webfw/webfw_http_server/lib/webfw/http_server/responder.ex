defmodule Webfw.HttpServer.Responder do
  @type method :: :GET | :POST | :PUT | :PATCH | :DELETE
  @callback resp(term(), method(), String.t()) :: Webfw.HttpResponse.t()
end
