# Coditsu Insights Engine

[![CircleCI](https://circleci.com/gh/coditsu/insights-engine/tree/master.svg?style=svg)](https://circleci.com/gh/coditsu/insights-engine/tree/master)

Coditsu Insights Engine allows us to get the "non-linter" related details about the current repository state. It allows us to get information useful during the diffing process and for displaying some meta-data in the UI.

## Installation

Add this line to your application Gemfile:

```ruby
gem 'insights-engine',
    git: 'git@github.com:coditsu/insights-engine.git',
    require: true,
    branch: :master
```

And then execute:

```
  $ bundle
```

## Usage

```ruby
require 'insights_engine'

InsightsEngine::Harvesters::HeadDetails::Engine.new.call(
  build_path: `pwd`.gsub("\n", '')
)

# Result

{
  commit_hash: '20575c9c17f2463505918c4d3ce0dc42f75a55cf',
  message: 'gem bump-2019-03-26',
  authored_at: 'Tue, 26 Mar 2019 18:43:22 +0100',
  committed_at: 'Tue, 26 Mar 2019 18:43:22 +0100',
  branch: 'master',
  diff_hash: 'b2a540b5aad4b5a6851687eff99f9b831c8b6906',
  author: {
    name: 'Maciej Mensfeld',
    email: 'maciej@mensfeld.pl'
  },
  committer: {
    name: 'Maciej Mensfeld',
    email: 'maciej@mensfeld.pl'
  }
}
```

## Note on contributions

First, thank you for considering contributing to Coditsu ecosystem! It's people like you that make the open source community such a great community!

Each pull request must pass all the RSpec specs and meet our quality requirements.

To check if everything is as it should be, we use [Coditsu](https://coditsu.io) that combines multiple linters and code analyzers for both code and documentation. Once you're done with your changes, submit a pull request.

Coditsu will automatically check your work against our quality standards. You can find your commit check results on the [builds page](https://app.coditsu.io/coditsu/commit_builds) of Coditsu organization.

[![coditsu](https://coditsu.io/assets/quality_bar.svg)](https://app.coditsu.io/coditsu/commit_builds)
