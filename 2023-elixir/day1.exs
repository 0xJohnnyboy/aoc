defmodule DAY1 do
  def find_first_digit(line, digits) do
    unless String.length(line) == 0 do
      if String.starts_with?(line, digits |> Map.keys()) do
        matching_key = find_start_matching_key(line, digits |> Map.keys())
        digits[matching_key]
      else
        find_first_digit(elem(String.split_at(line, 1), 1), digits)
      end
    end
  end

  def find_last_digit(line, digits) do
    line_length = String.length(line)
    unless line_length == 0 do
      if String.ends_with?(line, digits |> Map.keys()) do
        matching_key = find_end_matching_key(line, digits |> Map.keys())
        digits[matching_key]
      else
        find_last_digit(elem(String.split_at(line, -1), 0), digits)
      end
    end
  end

  defp find_end_matching_key(str, keys) do
    unless length(keys) == 0 do
      [head | tail] = keys

      if String.ends_with?(str, head) do
        head
      else
        find_end_matching_key(str, tail)
      end
    end
  end

  defp find_start_matching_key(str, keys) do
    unless length(keys) == 0 do
      [head | tail] = keys

      if String.starts_with?(str, head) do
        head
      else
        find_start_matching_key(str, tail)
      end
    end
  end

  def walk_lines([], _digits, sum), do: sum

  def walk_lines([head | tail], digits, sum) do
      first_dg = find_first_digit(head, digits)
      last_dg = find_last_digit(head, digits)
      case Integer.parse("#{first_dg}#{last_dg}") do
      {num, _} ->
        walk_lines(tail, digits, sum + num)
      _ ->
        walk_lines([], digits, sum)
    end  end
end

file_contents = File.read!("inputs/day1.txt")
lines = String.split(file_contents, "\n")
digits_map = %{
  "1" => "1",
  "one" => "1",
  "2" => "2",
  "two" => "2",
  "3" => "3",
  "three" => "3",
  "4" => "4",
  "four" => "4",
  "5" => "5",
  "five" => "5",
  "6" => "6",
  "six" => "6",
  "7" => "7",
  "seven" => "7",
  "8" => "8",
  "eight" => "8",
  "9" => "9",
  "nine" => "9",
}

sum = DAY1.walk_lines(lines, digits_map, 0)
IO.puts(sum)
