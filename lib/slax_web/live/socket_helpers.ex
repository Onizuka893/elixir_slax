defmodule SlaxWeb.SocketHelpers do
  def ok(socket) do
    {:ok, socket}
  end

  def noreply(socket), do: {:noreply, socket}
end
