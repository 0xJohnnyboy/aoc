defmodule DAY2 do

  defp get_game_map(str) do
    [cubes, color] = String.split(str, " ", parts: 2)
    cubes_nb = elem(Integer.parse(cubes), 0)
    IO.puts("getting map out of #{str}: {color: #{color}, cubes:#{cubes}}")

    %{color: color, cubes: cubes_nb}
  end

  defp get_rolls(str) do
    IO.puts("getting rolls out of #{str}")
    String.split(str, ", ", trim: true)
  end

  defp filter_color(map) do
    IO.puts("filtering #{inspect(map)}")
    case map.color do
      "red" -> map.cubes > 12
      "green" -> map.cubes > 13
      "blue" -> map.cubes > 14
      _ -> false
    end
  end

  def walk_lines([], sum), do: sum
  def walk_lines([head], sum), do: sum

  def walk_lines([head | tail], sum) do
      [game, rest] = String.split(head, ": ", parts: 2)
      [_, game_id_str] = String.split(game, " ", parts: 2)
      IO.puts("#{game_id_str}, sum: #{sum}")
      game_id=elem(Integer.parse(game_id_str), 0)

      games = String.split(rest, "; ")
        |> Enum.reduce([], fn curr, acc -> [get_rolls(curr) | acc] end)
        |> List.flatten()
        |> Enum.map(&get_game_map/1)
        |> Enum.filter(&filter_color/1)

      if length(games) > 0 do
        walk_lines(tail, sum)
      else
        walk_lines(tail, sum + game_id)
      end
    end  
end

file_contents = File.read!("inputs/day2.txt")
lines = String.split(file_contents, "\n")

sum = DAY2.walk_lines(lines, 0)
IO.puts(sum)
