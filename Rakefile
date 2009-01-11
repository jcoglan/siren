# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/siren.rb'

Hoe.new('siren', Siren::VERSION) do |p|
  # p.rubyforge_name = 'sirenx' # if different than lowercase project name
  p.developer('James Coglan', 'jcoglan@googlemail.com')
end

task :tt do
  %w(json json_query).each do |grammar|
    `tt lib/#{grammar}.tt`
  end
end

# vim: syntax=Ruby
