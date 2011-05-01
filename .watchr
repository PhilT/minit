def rspec spec
  system("clear && ruby #{spec}")
end

watch( 'lib/(.*)\.rb' ) {|match| rspec("spec/#{match[1]}_spec.rb") }
watch( 'spec/.*_spec\.rb' ) {|match| rspec(match[0]) }

