# IPPS Parser

Elixir library for parsing data from the [Inpatient Prospective Payment System (IPPS) Provider Summary](https://data.cms.gov/Medicare/Inpatient-Prospective-Payment-System-IPPS-Provider/97k6-zzx3).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ipps_parser to your list of dependencies in `mix.exs`:

        def deps do
          [{:ipps_parser, "~> 0.0.1"}]
        end

  2. Ensure ipps_parser is started before your application:

        def application do
          [applications: [:ipps_parser]]
        end
