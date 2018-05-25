defmodule Todo.ServerTest do
  use ExUnit.Case

  setup do
    Todo.Database.start()

    on_exit fn ->
      GenServer.stop(Todo.Database)
      db_path = Path.expand('persist')

      db_path
      |> File.rm_rf()
    end
  end

  test "adding entries" do
    {:ok, pid} = Todo.Server.start("a")
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-02], title: "Dentist"})
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] == Todo.Server.entries(pid, ~D[2018-01-01])

    Process.exit(pid, :kill)
  end

  test "updating entry using updater function" do
    {:ok, pid} = Todo.Server.start("b")
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-02], title: "Dentist"})
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-02], title: "Meeting"})

    Todo.Server.update_entry(pid, 1, fn entry -> %{entry | title: "Updated"} end)

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] == Todo.Server.entries(pid, ~D[2018-01-01])

    Process.exit(pid, :kill)
  end

  test "updating entry using new entry" do
    {:ok, pid} = Todo.Server.start("c")
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    Todo.Server.update_entry(pid, %{date: ~D[2018-01-01], id: 1, title: "Updated"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] == Todo.Server.entries(pid, ~D[2018-01-01])

    Process.exit(pid, :kill)
  end

  test "deleting entry using id" do
    Todo.Database.start()
    {:ok, pid} = Todo.Server.start("d")
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    Todo.Server.delete_entry(pid, 1)

    assert [] == Todo.Server.entries(pid, ~D[2018-01-01])

    Process.exit(pid, :kill)
  end
end
