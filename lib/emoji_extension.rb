module EmojiExtension
  def emoji(name)
    Emoji.find_by_alias(name).raw
  end

  def emoji_check_mark
    '✔'.colorize :light_green
  end

  def emoji_x_mark
    '✗'.colorize :red
  end

  def emoji_circle
    '◌'.colorize :cyan
  end
end
