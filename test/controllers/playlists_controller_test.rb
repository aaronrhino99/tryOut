require "test_helper"

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get playlists_index_url
    assert_response :success
  end

  test "should get show" do
    get playlists_show_url
    assert_response :success
  end

  test "should get create" do
    get playlists_create_url
    assert_response :success
  end

  test "should get update" do
    get playlists_update_url
    assert_response :success
  end

  test "should get destroy" do
    get playlists_destroy_url
    assert_response :success
  end

  test "should get add_song" do
    get playlists_add_song_url
    assert_response :success
  end

  test "should get remove_song" do
    get playlists_remove_song_url
    assert_response :success
  end
end
