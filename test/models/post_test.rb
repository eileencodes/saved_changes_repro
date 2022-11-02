require "test_helper"

class PostTest < ActiveSupport::TestCase
  def test_saved_changed
    post = posts(:one)
    post.update(title: "hello!")
    assert_empty post.saved_changes
  end
end
