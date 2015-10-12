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
    groups = Enum.group_by(payload, fn x -> {:ok, g} = Enum.fetch(x, key_index); g end)
    result = Map.keys(groups) |> Enum.map(fn x -> {:ok, k} = Map.fetch(groups, x);  {x, Enum.count(k)} end)
    Enum.sort(result, fn x, y -> {_, a} = x; {_, b} = y; a > b end)
  end
end
