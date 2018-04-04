defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test "new returns an empty map" do
    assert TodoList.new == %{}
  end

  test "simple todo list" do
    todo_list = TodoList.new
      |> TodoList.add_entry(~D[2018-01-01], "Dinner")
      |> TodoList.add_entry(~D[2018-01-02], "Dentist")

    assert ["Dinner"] == TodoList.entries(todo_list, ~D[2018-01-01])
    assert [] == TodoList.entries(todo_list, ~D[2018-01-03])
  end
end
