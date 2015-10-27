defmodule IppsParser do
  @moduledoc """
  IppsParser parses JSON from the Inpatient Prospective Payment System API
  and provides the ability to analyze and group based on a key in the JSON
  """

  @doc """
  Helper method for analyzing the key count of a given key from
  the live IPPS payload.
  """
  def analyze_key_for_ipps(key_index), do: analyze_key_counts(payment_json, key_index)

  @doc """
  Analyzes the 'data' payload and determines how many items exist for a given key
  Returns the grouped keys/counts.  [{key1, 123}, {key2, 345}]
  """
  def analyze_key_counts(payload, key_index) do
    groups = Enum.group_by(payload,
                &(_group_results(&1, key_index)))

    result = Map.keys(groups)
                |> _extract_counts(groups)

    Enum.sort(result, &(sorter(&1, &2)))
  end

  @doc """
  Reads the IPPS json from a url or the default
  Returns the content of the 'data' element
  """
  def payment_json(url \\ "https://data.cms.gov/api/views/97k6-zzx3/rows.json") do
    HTTPotion.start
    content = HTTPotion.get(url, [timeout: 60_000])
    parse_json(content.body)
  end

  @doc """
  Parses IPPS json
  Returns the content of 'data'
  """
  def parse_json(json_body) do
    {:ok, payload} = JSX.decode(json_body)
    payload["data"]
  end

  @doc """
  Sorts the objects {key, count} based on the count
  """
  def sorter(obj1, obj2) do
    {_, count1} = obj1
    {_, count2} = obj2
    count1 > count2
  end

  @doc """
  Run a map in parallel
  """
  def pmap(collection, function) do
    me = self
    collection
    |>
    Enum.map(fn (elem) ->
      spawn_link fn -> (send me, { self, function.(elem) }) end
    end) |>
    Enum.map(fn (pid) ->
      receive do { ^pid, result } -> result end
    end)
  end

  @doc """
  Groups the results of arr_item by the specified key index
  """
  defp _group_results(arr_item, key_index) do
    {:ok, group} = Enum.fetch(arr_item, key_index)
    group
  end

  @doc """
  Extracts a key and the count of times it occurs
  """
  defp _extract_counts(key_arr, groups) when is_list(key_arr) do
    pmap(key_arr, fn key ->
      {:ok, k} = Map.fetch(groups, key)
      {key, Enum.count(k)}
    end)
  end

end
