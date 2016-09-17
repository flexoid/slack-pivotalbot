defmodule PivotalBot.MessageFormatter do

  def build_message(stories, channel) do
    attachments = Enum.map stories, fn story -> attachment_for_story(story) end
    %{channel: channel, attachments: attachments, as_user: "true"}
  end

  defp attachment_for_story(story) do
    %{
      title: message_title(story),
      title_link: story["url"],
      text: story_description(story),
      fallback: story["name"],
      fields: [
        %{
          title: "State",
          value: story["current_state"],
          short: true
        },
        %{
          title: "Labels",
          value: story_labels_text(story),
          short: true
        }
      ]
    }
  end

  defp message_title(story) do
    title = story_image(story)
    if estimate_image(story) do
      title = "#{title} #{estimate_image(story)}"
    end
    "#{title} ##{story["id"]}"
  end

  defp story_description(story) do
    # display description under "show more" by inserting five linebreaks
    "#{story["name"]}\n\n\n\n\n#{story["description"]}"
  end

  defp story_labels_text(story) do
    story
    |> Map.get("labels", [])
    |> Enum.map(&Map.get(&1, "name"))
    |> Enum.join(", ")
  end

  defp story_image(story) do
    case story["story_type"] do
      "feature" -> ":star:"
      "bug"     -> ":beetle:"
      "chore"   -> ":gear:"
      "release" -> ":checkered_flag:"
      _         -> nil
    end
  end

  defp estimate_image(story) do
    case story["estimate"] do
      0 -> ":zero:"
      1 -> ":one:"
      2 -> ":two:"
      3 -> ":three:"
      4 -> ":four:"
      5 -> ":five:"
      6 -> ":six:"
      7 -> ":seven:"
      8 -> ":eight:"
      9 -> ":nine:"
      _ -> nil
    end
  end
end
