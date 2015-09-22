defmodule MyApp.ApiController do
  use MyApp.Web, :controller

  def files(conn, _params) do
    case File.ls do
      {:ok, files} -> json conn, files
    end
  end
end
