require 'time'
require 'bundler'
Bundler.require

Entry = Struct.new(:name, :raw) do
  def <=>(that)
    name <=> that.name
  end
end

entries = Emoji.all.flat_map do |emoji|
  emoji.aliases.map do |name|
    Entry.new(name, emoji.raw)
  end
end

entries.sort!

gemoji_version = Bundler.load.specs.find do |spec|
  spec.name == 'gemoji'
end.version.to_s

emojis = entries.map do |entry|
  "'#{entry.name}' '#{entry.raw}'"
end.join(" \\\n    ")

puts <<~END
  function emoji_codes -d "Fish implementation of emoji code source list"
      set emojis \\
      #{emojis}

      set is_key t

      for i in $emojis
          if test $is_key = t
              set is_key f
              set key $i
          else
              builtin echo "$i  $key"
              set is_key t
          end
      end
  end
END
