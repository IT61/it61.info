every :monday, at: "10am" do
  runner "notifications:events_digest"
end
