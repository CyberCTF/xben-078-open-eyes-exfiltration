#!/bin/sh
# The home page fills its category filter from the database (the blog is seeded).
curl -fsS --max-time 20 http://web/ | grep -q "<option value='"
