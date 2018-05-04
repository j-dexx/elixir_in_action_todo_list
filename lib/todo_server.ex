defmodule TodoServer do
  def start do
    spawn(fn ->
      Process.register(self(), :todo_server)
      loop(TodoList.new())
    end)
  end

  def entries(date) do
    send(:todo_server, {:entries, self(), date})

    receive do
      {:todo_entries, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  def add_entry(new_entry) do
    send(:todo_server, {:add_entry, new_entry})
  end

  def update_entry(new_entry) do
    send(:todo_server, {:update_entry, new_entry})
  end

  def update_entry(entry_id, updater_fun) do
    send(:todo_server, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(entry_id) do
    send(:todo_server, {:delete_entry, entry_id})
  end

  # Private API
  defp loop(todo_list) do
    new_todo_list =
      receive do
        message -> process_message(todo_list, message)
      end

    loop(new_todo_list)
  end

  # List entries
  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end

  # Add entry
  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  # Update entry with function
  defp process_message(todo_list, {:update_entry, entry_id, updater_fun}) do
    TodoList.update_entry(todo_list, entry_id, updater_fun)
  end

  # Update entry replace entry
  defp process_message(todo_list, {:update_entry, new_entry}) do
    TodoList.update_entry(todo_list, new_entry)
  end

  # Delete entry using id
  defp process_message(todo_list, {:delete_entry, entry_id}) do
    TodoList.delete_entry(todo_list, entry_id)
  end
end
