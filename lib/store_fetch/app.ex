defmodule StoreFetch.App do
  use Application
  require Logger

  def start(_type, _args) do
    case StoreFetch.Sup.start_link() do
      {:ok, pid} ->
        :ok = :riak_core.register([{:vnode_module, StoreFetch.Vnode}])
        :ok = :riak_core_node_watcher.service_up(StoreFetch.Service, self())
        {:ok, pid}
      {:error, reason} ->
        {:error, reason}
    end
  end
end


