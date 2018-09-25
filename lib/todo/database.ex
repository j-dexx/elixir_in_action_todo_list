defmodule Todo.Database do
  @db_folder "./persist"

  def child_spec(_) do
    File.mkdir_p!(@db_folder)

    :poolboy.child_spec(
      __MODULE__, # id of the child

      [
        name: {:local, __MODULE__}, # name for local registration
        worker_module: Todo.DatabaseWorker, # module which will power each worker
        size: 3,
      ],

      [@db_folder] # list of arguments passed to start_link of each worker
    )
  end

  def store(key, data) do
    # transaction makes a checkout request, invokes the lambda and returns the worker to the pool
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.store(worker_pid, key, data)
      end
    )
  end

  def get(key) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.get(worker_pid, key)
      end
    )
  end
end
