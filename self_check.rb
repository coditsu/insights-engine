# frozen_string_literal: true
require './lib/insights_engine.rb'

build_path = '/home/mencio/Software/Coditsu/Kabe'

results = InsightsEngine::Harvesters::GitInspector::Engine.new.call(
  build_path: build_path
)

p results
