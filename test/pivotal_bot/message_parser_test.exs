defmodule PivotalBot.MessageParserTest do
  use ExUnit.Case, async: true

  test "extracts story ids from the message" do
    message = """
    test message https://www.pivotaltracker.com/story/show/172893694 some text
    http://pivotaltracker.com/story/show/11237854 and
    another pivotaltracker.com/story/show/939764745
    and different
    format https://www.pivotaltracker.com/projects/12412/stories/873924 also
    should work
    https://www.pivotaltracker.com/n/projects/1234/stories/989213175
    """
    assert PivotalBot.MessageParser.parse(message) == [
      "172893694",
      "11237854",
      "939764745",
      "873924",
      "989213175"
    ]
  end

  test "returns empty list if there's no story ids in message" do
    message = """
    some message without links 123 http://example.com/123 other links
    here https://www.pivotaltracker.com/n/projects/41245
    """
    assert PivotalBot.MessageParser.parse(message) == []
  end

  test "extracts only uniq ids" do
    message = """
    pivotaltracker.com/story/show/123 and pivotaltracker.com/story/show/237
    and pivotaltracker.com/story/show/123
    """
    assert PivotalBot.MessageParser.parse(message) === ["123", "237"]
  end
end
