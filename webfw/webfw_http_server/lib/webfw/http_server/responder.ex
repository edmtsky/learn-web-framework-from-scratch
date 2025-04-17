defmodule Webfw.HTTPServer.Responder do
  @type method :: :GET | :POST | :PUT | :PATCH | :DELETE
  @callback resp(term(), method(), String.t()) :: Webfw.HTTPResponse.t()
end
