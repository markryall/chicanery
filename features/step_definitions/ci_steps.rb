Given /^I have ci jobs:$/ do |table|
  @jobs = table.hashes
end

Given /^a stdout ci handler$/ do
  @handlers ||= []
  @handlers << :stdout
end

When /^I engage in chicanery$/ do
  write_file 'configuration', ''
  run_simple 'chicanery configuration'
end