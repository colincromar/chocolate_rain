defmodule ChocolateRain do
  @moduledoc """
  Documentation for ChocolateRain.
  """
  use HTTPoison.Base
  alias ChocolateRain.Client

  def get(url, headers \\ []) do
    url
    |> call(headers)
    |> content_type
    |> decode
  end

  def content_type([{"Content-Type", val} | _]) do
    val
    |> String.split(";")
    |> List.first
  end

  def authorization_header(%{token: token}, headers) do
    headers ++ [{"Authorization", "Bearer #{token}"}]
  end

  def call(url, method, body \\ "", query_params \\ %{}, headers \ []) do
    HTTPoison.request(
      method,
      url |> clean_url,
      body |> encode(content_type(headers)),
      headers |> clean_headers,
      query_params |> clean_params
    )
    |> case do
        {:ok, %{body: raw, status_code: code, headers: headers}} ->
          {code, raw, headers}
        {:error, %{reason: reason}} -> {:error, reason, []}
       end
  end

  def decode({ok, body, "application/json"}) do
    body
    |> Poison.decode(keys: :atoms)
    |> case do
         {:ok, parsed} -> {ok, parsed}
         _ -> {:error, body}
       end
  end

end
