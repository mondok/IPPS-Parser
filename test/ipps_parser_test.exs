defmodule IppsParserTest do
  use ExUnit.Case
  doctest IppsParser

  setup do
    json = ~s({"data" : [ [ 1, "E98E544C-D753-4A26-931E-898451500516", 1, 1401378920, "701255", 1401378920, "701255", "{\n}", "039 - EXTRACRANIAL PROCEDURES W/O CC/MCC", "10001", "SOUTHEAST ALABAMA MEDICAL CENTER", "1108 ROSS CLARK CIRCLE", "DOTHAN", "AL", "36301", "AL - Dothan", "91", "32963.07", "5777.24", "4763.73" ],[ 2, "580DB674-547D-4EEE-9951-A58AB38B8828", 2, 1401378920, "701255", 1401378920, "701255", "{\n}", "039 - EXTRACRANIAL PROCEDURES W/O CC/MCC", "10005", "MARSHALL MEDICAL CENTER SOUTH", "2505 U S HIGHWAY 431 NORTH", "BOAZ", "AL", "35957", "AL - Birmingham", "14", "15131.85", "5787.57", "4976.71" ]]})
    {:ok, json: json}
  end

  test "can parse json", %{json: json} do
    content = IppsParser.parse_json(json)
    assert content != nil
  end

  test "can analyze json", %{json: json} do
    content = IppsParser.parse_json(json)
    result = IppsParser.analyze_key_counts(content, 1)
  end
end
