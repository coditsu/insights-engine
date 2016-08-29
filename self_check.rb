# frozen_string_literal: true
require './lib/ninshiki.rb'

build_path = '/home/mencio/Software/Senpuu'

results = Ninshiki::Harvesters::CommitsDetails::Engine.new.call(
  build_path: build_path
)

p results
