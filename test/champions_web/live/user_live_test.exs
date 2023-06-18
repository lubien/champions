defmodule ChampionsWeb.UserLiveTest do
  use ChampionsWeb.ConnCase

  alias Champions.Accounts
  import Phoenix.LiveViewTest
  import Champions.AccountsFixtures

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  describe "Index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      {:ok, _index_live, html} = live(conn, ~p"/users")

      assert html =~ "Listing Users"
      assert html =~ user.email
    end
  end

  describe "Authenticated Show" do
    setup [:register_and_log_in_user]

    test "displays my own user but no action buttons", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/users/#{user}")

      assert html =~ "This is a player on this app"
      assert html =~ user.email
      refute html =~ "I lost to this person"
      refute html =~ "Declare draw match"
    end

    test "displays another user with action buttons", %{conn: conn, user: _user} do
      other_user = user_fixture()
      {:ok, _show_live, html} = live(conn, ~p"/users/#{other_user}")

      assert html =~ "This is a player on this app"
      assert html =~ other_user.email
      assert html =~ "I lost to this person"
      assert html =~ "Declare draw match"
    end

    test "concede 3 points when I lose to another player", %{conn: conn, user: _user} do
      other_user = user_fixture()
      {:ok, show_live, _html} = live(conn, ~p"/users/#{other_user}")

      assert other_user.points == 0
      assert show_live |> element("button", "I lost to this person") |> render_click()
      assert element(show_live, "span[data-points]") |> render() =~ "3"
      assert Accounts.get_user!(other_user.id).points == 3
    end

    test "concede 1 point to each user when there's a draw match", %{conn: conn, user: user} do
      other_user = user_fixture()
      {:ok, show_live, _html} = live(conn, ~p"/users/#{other_user}")

      assert user.points == 0
      assert other_user.points == 0
      assert show_live |> element("button", "Declare draw match") |> render_click()
      assert element(show_live, "span[data-my-points]") |> render() =~ "1"
      assert element(show_live, "span[data-points]") |> render() =~ "1"
      assert Accounts.get_user!(user.id).points == 1
      assert Accounts.get_user!(other_user.id).points == 1
    end
  end

  describe "Show" do
    setup [:create_user]

    test "displays user", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/users/#{user}")

      assert html =~ "This is a player on this app"
      assert html =~ user.email
      refute html =~ "I lost to this person"
      refute html =~ "Declare draw match"
    end
  end
end
