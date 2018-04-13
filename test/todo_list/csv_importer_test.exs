defmodule TodoList.CsvImporterTest do
  use ExUnit.Case
  doctest TodoList.CsvImporter

  test "imports CSV into todolist" do
    csv_path = Path.expand("../support/todos.csv")

    todo_list = TodoList.CsvImporter.import(csv_path)

    assert [%{date: ~D[2018-12-19], id: 1, title: "Dentist"}, %{date: ~D[2018-12-19], id: 3, title: "Movies"}] == TodoList.entries(todo_list, ~D[2018-12-19])
    assert [%{date: ~D[2018-12-20], id: 2, title: "Shopping"}] == TodoList.entries(todo_list, ~D[2018-12-20])
  end
end