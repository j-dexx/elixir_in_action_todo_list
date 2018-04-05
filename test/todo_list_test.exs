defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test "new returns an empty map" do
    assert TodoList.new == %{}
  end

  test "simple todo list" do
    entry = %{date: ~D[2018-01-01], title: "Dinner"}
    another_entry = %{date: ~D[2018-01-02], title: "Dentist"}

    todo_list = TodoList.new
      |> TodoList.add_entry(entry)
      |> TodoList.add_entry(another_entry)

    assert [entry] == TodoList.entries(todo_list, ~D[2018-01-01])
    assert [] == TodoList.entries(todo_list, ~D[2018-01-03])
  end
end
