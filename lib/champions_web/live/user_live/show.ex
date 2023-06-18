defmodule ChampionsWeb.UserLive.Show do
  use ChampionsWeb, :live_view

  alias Champions.Accounts

  @impl true
  def handle_params(%{"id" => id}, _session, socket) do
    user = Accounts.get_user!(id)
    {:noreply,
     socket
     |> assign(:page_title, "Showing user #{user.email}")
     |> assign(:user, user)}
  end

  @impl true
  def handle_event(_event_name, _value, %{assigns: %{current_user: nil}} = socket) do
    {:noreply, put_flash(socket, :error, "You must be a player to do that!")}
  end

  def handle_event(_event_name, _value, %{assigns: %{current_user: current_user, user: user}} = socket)
    when current_user.id == user.id do
    {:noreply, put_flash(socket, :error, "You can't give points to yourself")}
  end

  def handle_event("concede_loss", _value, %{assigns: %{user: user}} = socket) do
    {:ok, updated_user} = Accounts.update_user_points(user, user.points + 3)
    {:noreply, assign(socket, :user, updated_user)}
  end

  def handle_event("concede_draw", _value, %{assigns: %{current_user: current_user, user: user}} = socket) do
    {:ok, updated_user} = Accounts.update_user_points(user, user.points + 1)
    {:ok, updated_my_user} = Accounts.update_user_points(current_user, current_user.points + 1)
    {:noreply,
      socket
      |> assign(:user, updated_user)
      |> assign(:current_user, updated_my_user)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      User <%= @user.id %>
      <:subtitle>This is a player on this app.</:subtitle>
    </.header>

    <.list>
      <:item title="Email"><%= @user.email %></:item>
      <:item title="Points"><span data-points><%= @user.points %></span></:item>
    </.list>

    <div :if={@current_user && @current_user.id != @user.id} class="my-4">
      <.button type="button" phx-click="concede_loss">I lost to this person</.button>
      <.button type="button" phx-click="concede_draw">Declare draw match</.button>
    </div>

    <.back navigate={~p"/users"}>Back to users</.back>
    """
  end
end
