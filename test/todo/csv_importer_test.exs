defmodule Todo.CsvImporterTest do
  use ExUnit.Case
  doctest Todo.CsvImporter

  test "imports CSV into Todo.List" do
    csv_path = Path.expand("./test/support/todos.csv")

    todo_list = Todo.CsvImporter.import(csv_path)

    assert [%{date: ~D[2018-12-19], id: 1, title: "Dentist"}, %{date: ~D[2018-12-19], id: 3, title: "Movies"}] == Todo.List.entries(todo_list, ~D[2018-12-19])
    assert [%{date: ~D[2018-12-20], id: 2, title: "Shopping"}] == Todo.List.entries(todo_list, ~D[2018-12-20])
  end
end
