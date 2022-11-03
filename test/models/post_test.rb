require "test_helper"

$REVERT_46282 = false

ActiveModel::Attribute.alias_method :original_forgetting_assignment, :forgetting_assignment
ActiveModel::Attribute.const_get(:FromDatabase).prepend(Module.new do
  def forgetting_assignment
    $REVERT_46282 ? original_forgetting_assignment : super
  end
end)

class Post
  def probe!(read_field: false)
    puts " field_before_type_cast: #{field_before_type_cast.inspect}"
    puts "field changed_in_place?: #{@attributes["field"].changed_in_place?.inspect}"
    puts "                changes: #{changes}"

    if read_field
      puts "---------- AFTER READ `field` ----------"
      puts "            field value: #{field.inspect}"
      puts "field changed_in_place?: #{@attributes["field"].changed_in_place?.inspect}"
      puts "                changes: #{changes}"
    end

    puts
  end
end

class PostTest < ActiveSupport::TestCase
  def test_saved_changed
    post = posts(:one)

    $REVERT_46282 = true

    puts "$REVERT_46282: #{$REVERT_46282.inspect}"

    puts "\n========== BEFORE UPDATE `title` =========="
    # post.probe!(read_field: true)
    post.probe!

    post.update(title: "hello!")

    puts "\n========== AFTER UPDATE `title` =========="
    post.probe!(read_field: true)

    post.reload

    puts "\n========== AFTER RELOAD =========="
    post.probe!(read_field: true)

    assert_empty post.changes
  end
end
