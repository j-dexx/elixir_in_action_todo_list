defmodule TodoServerTest do
  use ExUnit.Case


  test "adding entries" do
    pid = TodoServer.start()
    TodoServer.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Dentist"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] == TodoServer.entries(pid, ~D[2018-01-01])
  end

  test "updating entry using updater function" do
    pid = TodoServer.start()
    TodoServer.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Dentist"})
    TodoServer.add_entry(pid, %{date: ~D[2018-01-02], title: "Meeting"})

    TodoServer.update_entry(pid, 1, fn entry -> %{entry | title: "Updated"} end)

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] == TodoServer.entries(pid, ~D[2018-01-01])
  end

  test "updating entry using new entry" do
    pid = TodoServer.start()
    TodoServer.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.update_entry(pid, %{date: ~D[2018-01-01], id: 1, title: "Updated"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] == TodoServer.entries(pid, ~D[2018-01-01])
  end

  test "deleting entry using id" do
    pid = TodoServer.start()
    TodoServer.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    TodoServer.delete_entry(pid, 1)

    assert [] == TodoServer.entries(pid, ~D[2018-01-01])
  end
end
