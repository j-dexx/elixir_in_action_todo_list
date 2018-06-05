defmodule Todo.Server do
  use GenServer

  def start(name) do
    IO.puts("Starting to-do server for #{name}.")

    GenServer.start(__MODULE__, name)
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
  def init(name) do
    {:ok, { name, Todo.Database.get(name) || Todo.List.new() }}
  end

  # List entries
  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
  end

  # Add entry
  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  # Update entry with function
  @impl GenServer
  def handle_cast({:update_entry, entry_id, updater_fun}, {name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, entry_id, updater_fun)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  # Update entry replace entry
  @impl GenServer
  def handle_cast({:update_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  # Delete entry using id
  @impl GenServer
  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end
end
