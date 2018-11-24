#!/usr/bin/env ruby
require 'ruby_erd'

options = OptionsStruct.new
options.parse ARGV

current_dir = Dir.pwd

Dir.chdir(options.root) if options.root != ''

graph = RubyErd::Generator.new(options)

graph.process
graph.generate

Dir.chdir(current_dir)

graph.print
