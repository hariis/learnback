atom_feed do |feed|
  feed.title "Lessons Learned Feedback Entries"
  feed.updated @opinions.first.created_at
  for page in @opinions
    feed.entry(page) do |entry|
      entry.title   "#{page.dept} + Feedback Number #{page.id}"
      entry.content page.description, :type => 'html'
      entry.author do |author|
        author.name page.user.login
      end
    end
  end
end