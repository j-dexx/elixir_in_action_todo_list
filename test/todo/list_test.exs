defmodule Todo.ListTest do
  use ExUnit.Case
  doctest Todo.List

  test "new returns an empty struct" do
    assert Todo.List.new == %Todo.List{}
  end

  test "simple todo list" do
    todo_list = Todo.List.new
      |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] == Todo.List.entries(todo_list, ~D[2018-01-01])
    assert [] == Todo.List.entries(todo_list, ~D[2018-01-03])
  end

  test "todo updating entry" do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] ==
             todo_list
             |> Todo.List.update_entry(1, fn entry -> %{entry | title: "Updated"} end)
             |> Todo.List.entries(~D[2018-01-01])

  end

  test "deleting entry" do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})

    assert [] ==
             todo_list
             |> Todo.List.delete_entry(1)
             |> Todo.List.entries(~D[2018-01-01])
  end

  test "instantiate with multiple entries" do
    entries = [
      %{date: ~D[2018-12-19], title: "Dentist"},
      %{date: ~D[2018-12-20], title: "Shopping"},
      %{date: ~D[2018-12-19], title: "Movies"}
    ]

    todo_list = Todo.List.new(entries)

    expected = [%{date: ~D[2018-12-19], id: 1, title: "Dentist"}, %{date: ~D[2018-12-19], id: 3, title: "Movies"}]

    assert expected == Todo.List.entries(todo_list, ~D[2018-12-19])
  end

  test "implementing collectable protocol" do
    entries = [
      %{date: ~D[2018-12-19], title: "Dentist"},
      %{date: ~D[2018-12-20], title: "Shopping"},
      %{date: ~D[2018-12-19], title: "Movies"}
    ]

    todo_list = for entry <- entries, into: Todo.List.new(), do: entry

    expected = [%{date: ~D[2018-12-19], id: 1, title: "Dentist"}, %{date: ~D[2018-12-19], id: 3, title: "Movies"}]

    assert expected == Todo.List.entries(todo_list, ~D[2018-12-19])

    expected = [%{date: ~D[2018-12-20], id: 2, title: "Shopping"}]

    assert expected == Todo.List.entries(todo_list, ~D[2018-12-20])
  end
end
