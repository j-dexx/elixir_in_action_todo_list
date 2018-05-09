defmodule TodoServer do
  def start do
    ServerProcess.start(__MODULE__)
  end

  def entries(pid, date) do
    ServerProcess.call(pid, {:entries, date})
  end

  def add_entry(pid, new_entry) do
    ServerProcess.cast(pid, {:add_entry, new_entry})
  end

  def update_entry(pid, new_entry) do
    ServerProcess.cast(pid, {:update_entry, new_entry})
  end

  def update_entry(pid, entry_id, updater_fun) do
    ServerProcess.cast(pid, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(pid, entry_id) do
    ServerProcess.cast(pid, {:delete_entry, entry_id})
  end

  def init do
    TodoList.new
  end

  # List entries
  def handle_call({:entries, date}, todo_list) do
    {TodoList.entries(todo_list, date), todo_list}
  end

  # Add entry
  def handle_cast({:add_entry, new_entry}, todo_list) do
    TodoList.add_entry(todo_list, new_entry)
  end

  # Update entry with function
  def handle_cast({:update_entry, entry_id, updater_fun}, todo_list) do
    TodoList.update_entry(todo_list, entry_id, updater_fun)
  end

  # Update entry replace entry
  def handle_cast({:update_entry, new_entry}, todo_list) do
    TodoList.update_entry(todo_list, new_entry)
  end

  # Delete entry using id
  def handle_cast({:delete_entry, entry_id}, todo_list) do
    TodoList.delete_entry(todo_list, entry_id)
  end
end
