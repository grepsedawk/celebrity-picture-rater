# Celebrity Picture Rater

[![CircleCI](https://circleci.com/gh/Mingosio/celebrity-picture-rater/tree/master.svg?style=svg)](https://circleci.com/gh/Mingosio/celebrity-picture-rater/tree/master) [![Heroku](https://heroku-badge.herokuapp.com/?app=celebrity-picture-rater)](https://celebrity-picture-rater.herokuapp.com/)

At Mingos.io, we share a high volume of celebrity photos. We really wanted to find the best photo for each celebrity, so we made a celebrity picture rater in search for that answer.

## Getting Started

### Prerequisites

```plaintext
ruby 2.5.0
nodejs 8.9.3
  - yarn
postgres 9.6
```

### Installing

Ensure all prerequisites are installed then run:

```bash
bin/setup
```

After that, you can run:

```bash
bundle exec rails s
```

To enable live reloading, you can run the `webpack-dev-server` with:

```bash
bin/webpack-dev-server
```

## Running the Tests

### RSpec

Ensure you have `google-chrome` installed, then you can run the tests with `bundle exec rake`.

### Style Tests

`rubocop` can run the style suite. All PRs require the style suite to pass 100% and the style suite is included in CI.
