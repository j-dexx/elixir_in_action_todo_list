defmodule Todo.Server do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def entries(todo_list, date) do
    GenServer.call(todo_list, {:entries, date})
  end

  def add_entry(todo_list, new_entry) do
    GenServer.cast(todo_list, {:add_entry, new_entry})
  end

  def update_entry(todo_list, new_entry) do
    GenServer.cast(todo_list, {:update_entry, new_entry})
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    GenServer.cast(todo_list, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(todo_list, entry_id) do
    GenServer.cast(todo_list, {:delete_entry, entry_id})
  end

  @impl GenServer
  def init(_) do
    {:ok, Todo.List.new}
  end

  # List entries
  @impl GenServer
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end

  # Add entry
  @impl GenServer
  def handle_cast({:add_entry, new_entry}, todo_list) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    {:noreply, new_state}
  end

  # Update entry with function
  @impl GenServer
  def handle_cast({:update_entry, entry_id, updater_fun}, todo_list) do
    new_state = Todo.List.update_entry(todo_list, entry_id, updater_fun)
    {:noreply, new_state}
  end

  # Update entry replace entry
  @impl GenServer
  def handle_cast({:update_entry, new_entry}, todo_list) do
    new_state = Todo.List.update_entry(todo_list, new_entry)
    {:noreply, new_state}
  end

  # Delete entry using id
  @impl GenServer
  def handle_cast({:delete_entry, entry_id}, todo_list) do
    new_state = Todo.List.delete_entry(todo_list, entry_id)
    {:noreply, new_state}
  end
end
