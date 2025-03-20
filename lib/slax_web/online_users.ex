defmodule SlaxWeb.OnlineUsers do
  alias SlaxWeb.Presence

  @topic "online_users"

  def list() do
    @topic
    |> Presence.list()
    |> Enum.into(%{}, fn {id, %{metas: metas}} ->
      {String.to_integer(id), length(metas)}
    end)
  end

  def track(pid, user) do
    {:ok, _} = Presence.track(pid, @topic, user.id, %{})
    :ok
  end

  def online?(online_users, user_id) do
    Map.get(online_users, user_id, 0) > 0
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Slax.PubSub, @topic)
  end

  def update(online_users, %{joins: joins, leaves: leaves}) do
    online_users
    |> process_updates(joins, &Kernel.+/2)
    |> process_updates(leaves, &Kernel.-/2)
  end

  defp process_updates(online_users, updates, operation) do
    # reduce sums the map values by id
    # Kernel.+/2 is just added 2 numbers
    # test = Kernel.+/2 passed anonymous function to new variable
    # test.(1,1) => 2 variable can be used as the passed down function
    Enum.reduce(updates, online_users, fn {id, %{metas: metas}}, acc ->
      # here again an anonymous function is => the value of the key = &1 gets added to the length(metas)
      Map.update(acc, String.to_integer(id), length(metas), &operation.(&1, length(metas)))
    end)
  end
end
