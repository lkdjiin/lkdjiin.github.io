#!/bin/fish

# Usage: give a tag (or some tags) to delete.
# Example: ./delete_tag.fish one two 'a third one'
for tag in $argv
  echo =-=-= Processing $tag =-=-=

  for file in _posts/*.markdown
    # Get the line number of the tag, if any.
    set tag_line (grep -nE "^tags:.*$tag" $file | cut -d : -f 1)

    if test -n "$tag_line"
      echo Remove $tag from $file
      # First try to remove ', tag', then 'tag,' and finally 'tag'.
      sed -i $tag_line"s/, "$tag"//" $file
      sed -i $tag_line"s/"$tag",//" $file
      sed -i $tag_line"s/"$tag"//" $file
    end
  end
end
