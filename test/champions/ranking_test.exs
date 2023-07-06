defmodule Champions.RankingTest do
  use Champions.DataCase

  alias Champions.Ranking
  alias Champions.Accounts.User
  import Champions.AccountsFixtures

  describe "change_user_points/2" do
    test "accepts non-negative integers" do
      assert %Ecto.Changeset{} = changeset = Ranking.change_user_points(%User{}, %{"points" => -1})
      refute changeset.valid?

      assert %Ecto.Changeset{} = changeset = Ranking.change_user_points(%User{}, %{"points" => 0})
      assert changeset.valid?

      assert %Ecto.Changeset{} = changeset = Ranking.change_user_points(%User{}, %{"points" => 10})
      assert changeset.valid?
    end
  end

  describe "set_user_points/2" do
    setup do
      %{user: user_fixture()}
    end

    test "updates the amounts of points of an existing user", %{user: user} do
      {:ok, updated_user} = Ranking.update_user_points(user, 10)
      assert updated_user.points == 10
    end
  end

  describe "concede_loss_to/2" do
    test "adds 3 points to the winner" do
      loser = user_fixture()
      user = user_fixture()
      assert user.points == 0
      assert {:ok, %User{points: 3}} = Ranking.concede_loss_to(loser, user)
    end
  end

  describe "declare_draw_match/2" do
    test "adds 1 point to each user" do
      user_a = user_fixture()
      user_b = user_fixture()
      assert user_a.points == 0
      assert user_b.points == 0
      assert {:ok, %User{points: 1}, %User{points: 1}} = Ranking.declare_draw_match(user_a, user_b)
    end
  end

  describe "increment_user_points/2" do
    test "performs an atomic increment on a single user points amount" do
      user = user_fixture()
      assert user.points == 0
      assert {:ok, %User{points: 10}} = Ranking.increment_user_points(user, 10)
      assert {:ok, %User{points: 5}} = Ranking.update_user_points(user, 5)
      assert {:ok, %User{points: 15}} = Ranking.increment_user_points(user, 10)
    end
  end
end
