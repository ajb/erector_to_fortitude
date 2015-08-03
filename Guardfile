guard :rspec, cmd: 'bundle exec rspec', failed_mode: :focus do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})         { |m| "spec/lib/erector_to_fortitude/converter_spec.rb" }
end
