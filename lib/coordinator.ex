defmodule Metex.Coordinator do
  def loop(results \\ [], count) do
    receive do
      {:ok, result} ->
        new_results = [result|results]
        if Enum.count(new_results) == count do
          send(self, :exit)
        end
        loop(new_results, count)
      :exit ->
        results |> Enum.sort |> Enum.join(", ") |> IO.puts
      _ ->
        loop(results, count)
    end
  end
end