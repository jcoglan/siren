# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/siren.rb'

Hoe.spec('siren') do |p|
  # p.rubyforge_name = 'sirenx' # if different than lowercase project name
  p.developer('James Coglan', 'jcoglan@googlemail.com')
  p.extra_deps = %w[treetop eventful]
end

task :tt do
  %w(json json_query).each do |grammar|
    `tt lib/siren/#{grammar}.tt`
  end
end

# vim: syntax=Ruby
