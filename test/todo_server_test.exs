defmodule TodoServerTest do
  use ExUnit.Case

  setup do
    on_exit fn ->
      Process.whereis(:todo_server)
      |> Process.exit(:kill)
    end
  end

  test "adding entries" do
    TodoServer.start()
    :timer.sleep(100)
    TodoServer.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
    TodoServer.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] == TodoServer.entries(~D[2018-01-01])
  end

  test "updating entry using updater function" do
    TodoServer.start()
    :timer.sleep(100)
    TodoServer.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
    TodoServer.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})

    TodoServer.update_entry(1, fn entry -> %{entry | title: "Updated"} end)

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] == TodoServer.entries(~D[2018-01-01])
  end

  test "updating entry using new entry" do
    TodoServer.start()
    :timer.sleep(100)
    TodoServer.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.update_entry(%{date: ~D[2018-01-01], id: 1, title: "Updated"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] == TodoServer.entries(~D[2018-01-01])
  end

  test "deleting entry using id" do
    TodoServer.start()
    :timer.sleep(100)
    TodoServer.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.delete_entry(1)

    assert [] == TodoServer.entries(~D[2018-01-01])
  end
end
