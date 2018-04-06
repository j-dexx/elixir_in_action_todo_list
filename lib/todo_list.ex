defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %TodoList{}

  def add_entry(todo_list = %TodoList{}, entry) do
    # Set the id for the entry
    entry = Map.put(entry, :id, todo_list.auto_id)

    # Add the entry
    new_entries = Map.put(
      todo_list.entries,
      todo_list.auto_id,
      entry
    )

    # Increment the auto_id field
    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def update_entry(todo_list = %TodoList{}, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry) # Ensure id has not changed by updater lambda
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  # Alternative update interface - passing a new entry to replace an old one
  def update_entry(todo_list = %TodoList{}, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def delete_entry(todo_list = %TodoList{}, entry_id) do
    new_entries = Map.delete(todo_list.entries, entry_id)
    %TodoList{todo_list | entries: new_entries}
  end

  # Use stream then enum so both transformations happen in single pass through the collection
  def entries(todo_list = %TodoList{}, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
end
