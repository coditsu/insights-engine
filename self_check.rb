# frozen_string_literal: true

require './lib/insights_engine.rb'

build_path = '/home/mencio/Software/Coditsu/Apps/Kabe'

p InsightsEngine::Harvesters::GitInspector::Engine.new.call(
  build_path: build_path,
  snapshotted_at: Date.today
)
