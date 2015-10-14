defmodule IppsParser do

  @doc """
  Reads the IPPS json from a url or the default
  Returns the content of the 'data' element
  """
  def read_payment_json(url \\ "https://data.cms.gov/api/views/97k6-zzx3/rows.json") do
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
  Analyzes the 'data' payload and determines how many items exist for a given key
  Returns the grouped keys/counts.  [{key1, 123}, {key2, 345}]
  """
  def analyze_key_counts(payload, key_index) do
    groups = Enum.group_by(payload,
                &(group_results(&1, key_index)))

    result = Map.keys(groups)
                |> extract_counts(groups)

    Enum.sort(result, &(sorter(&1, &2)))
  end

  @doc """
  Groups the results of arr_item by the specified key index
  """
  def group_results(arr_item, key_index) do
    {:ok, group} = Enum.fetch(arr_item, key_index)
    group
  end

  @doc """
  Extracts a key and the count of times it occurs
  """
  def extract_counts(key_arr, groups) do
    Enum.map(key_arr, fn key ->
      {:ok, k} = Map.fetch(groups, key)
      {key, Enum.count(k)}
    end)
  end

  @doc """
  Sorts the objects {key, count} based on the count
  """
  def sorter(obj1, obj2) do
    {_, count1} = obj1
    {_, count2} = obj2
    count1 > count2
  end

end
