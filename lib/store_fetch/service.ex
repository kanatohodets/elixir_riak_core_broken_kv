defmodule StoreFetch.Service do
  def store(key, data) do
    doc_idx = :riak_core_util.chash_key({"store", :erlang.term_to_binary(key)})
    pref_list = :riak_core_apl.get_primary_apl(doc_idx, 1, StoreFetch.Service)
    [{index_node, _type}] = pref_list
    # riak core appends "_master" to StoreFetch.Vnode.
    :riak_core_vnode_master.sync_spawn_command(index_node, {:store, key, data}, StoreFetch.Vnode_master)
  end
  def fetch(key) do
    doc_idx = :riak_core_util.chash_key({"store", :erlang.term_to_binary(key)})
    pref_list = :riak_core_apl.get_primary_apl(doc_idx, 1, StoreFetch.Service)
    [{index_node, _type}] = pref_list
    # riak core appends "_master" to StoreFetch.Vnode.
    :riak_core_vnode_master.sync_spawn_command(index_node, {:fetch, key}, StoreFetch.Vnode_master)
  end
end
