defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test "new returns an empty struct" do
    assert TodoList.new == %TodoList{}
  end

  test "simple todo list" do
    todo_list = TodoList.new
      |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
      |> TodoList.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] == TodoList.entries(todo_list, ~D[2018-01-01])
    assert [] == TodoList.entries(todo_list, ~D[2018-01-03])
  end

  test "todo updating entry" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
      |> TodoList.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] ==
             todo_list
             |> TodoList.update_entry(1, fn entry -> %{entry | title: "Updated"} end)
             |> TodoList.entries(~D[2018-01-01])

  end

  test "deleting entry" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
      |> TodoList.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})

    assert [] ==
             todo_list
             |> TodoList.delete_entry(1)
             |> TodoList.entries(~D[2018-01-01])
  end
end
