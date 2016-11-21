defmodule Metex.Worker do
  def loop do
    receive do
      {pid, city} ->
        send(pid, {:ok, temperature_of(city)})
        loop
      _ ->
        IO.puts "I don't know what to do!"
    end
  end

  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get |> parse_response

    case result do
      {:ok, temp} ->
        "#{location}: #{temp}C"
      :error ->
        "#{location} not found"
    end
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey}"
  end

  defp apikey do
    "not-api-key"
  end
end
