defmodule ChampionsWeb.UserLive.Index do
  use ChampionsWeb, :live_view

  alias Champions.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:page_title, "Listing Users")
      |> stream(:users, Accounts.list_users())
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Users
    </.header>

    <.table
      id="users"
      rows={@streams.users}
    >
      <:col :let={{_id, user}} label="Email"><%= user.email %></:col>
      <:col :let={{_id, user}} label="Points"><%= user.points %></:col>
    </.table>
    """
  end
end
