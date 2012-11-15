require 'erb'

Given /^I have ci jobs:$/ do |table|
  @jobs = table.hashes
end

Given /^a stdout ci handler$/ do
  @handlers = <<EOF
when_anything do |state|
  state.jobs each do |job|
    puts "#{job.name} is #{job.status}"
  end
end
EOF
end

When /^I engage in chicanery$/ do
  jobs, handlers = @jobs, @handlers
  template = ERB.new <<EOF
<% @jobs.each do |job| %>
  job "<%= job['name'] %>
<% end %>

<% @handlers %>
EOF
  write_file 'configuration', template.result(binding)
  run_simple 'chicanery configuration'
end