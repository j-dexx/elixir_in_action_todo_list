defmodule Todo.Server do
  use GenServer, restart: :temporary
  @expiry_idle_timeout :timer.seconds(10)

  def start_link(name) do
    IO.puts("Starting to-do server for #{name}.")

    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
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
    {
      :ok,
      { name, Todo.Database.get(name) || Todo.List.new() },
      @expiry_idle_timeout
    }
  end

  # List entries
  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      {name, todo_list},
      @expiry_idle_timeout
    }
  end

  # Add entry
  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}, @expiry_idle_timeout}
  end

  # Update entry with function
  @impl GenServer
  def handle_cast({:update_entry, entry_id, updater_fun}, {name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, entry_id, updater_fun)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}, @expiry_idle_timeout}
  end

  # Update entry replace entry
  @impl GenServer
  def handle_cast({:update_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}, @expiry_idle_timeout}
  end

  # Delete entry using id
  @impl GenServer
  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, {name, todo_list}) do
    IO.puts("Stopping to-do server for #{name}")
    {:stop, :normal, {name, todo_list}}
  end

  def handle_info(unknown_message, state) do
    super(unknown_message, state)
    {:noreply, state, @expiry_idle_timeout}
  end
end
