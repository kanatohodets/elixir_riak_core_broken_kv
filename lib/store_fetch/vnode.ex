defmodule StoreFetch.Vnode do
  @behaviour :riak_core_vnode

  def start_vnode(part) do
    :riak_core_vnode_master.get_vnode_pid(part, __MODULE__)
  end

  def init([_part]) do
    ets_handle = :ets.new(nil, [])
    {:ok, %{db: ets_handle}}
  end

  def handle_command({:store, key, data}, _sender, %{db: db} = state) do
    result = :ets.insert(db, {key, data})
    {:reply, result, state}
  end

  def handle_command({:fetch, key}, _sender, %{db: db} = state) do
    case :ets.lookup(db, key) do
      [] -> {:reply, :not_found, state}
      [{key, data}] -> {:reply, {key, data}, state}
    end
  end

  def handle_command(_message, _sender, state) do
    {:reply, :unknown_message, state}
  end

  def handle_handoff_command(_fold_req, _sender, state) do
    {:noreply, state}
  end

  def handle_handoff_command(_message, _sender, state) do
    {:noreply, state}
  end

  def handoff_starting(_target_node, state) do
    {true, state}
  end

  def handoff_cancelled(state) do
    {:ok, state}
  end

  def handoff_finished(_target_node, state) do
    {:ok, state}
  end

  def handle_handoff_data(_data, state) do
    {:reply, :ok, state}
  end

  def encode_handoff_item(_object_name, _object_value) do
    ""
  end

  def is_empty(state) do
    {true, state}
  end

  def delete(%{db: db}=state) do
    :ets.delete(db)
    {:ok, state}
  end

  def handle_coverage(_req, _key_spaces, _sender, state) do
    {:stop, :not_implemented, state}
  end

  def handle_exit(_pid, _reason, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    :ok
  end
end
