# Create 2 users

userone = User.create(name: "User1", email: "user1@one.com", password: "password")
usertwo = User.create(name: "User2", email: "user2@two.com", password: "password")

# Create a build entry

BuildEntry.create(title: "Seeded Entry", content: "Entry here", user_id: userone.id)

# Use AR to pre-associate data:

userone.build_entries.create(title: "Second Entry", content: "Second entry here")

usertwo_entry = usertwo.build_entries.build(title: "Different Entry", content: "Different entry here")
usertwo_entry.save
