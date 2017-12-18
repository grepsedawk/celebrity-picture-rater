# frozen_string_literal: true

# This is required for the after hook that calls save_spec_screenshot towards
# the end of rails_helper.rb
#
# The Capybara RSpec setup calls Capybara.reset_sessions! in the rspec setup
# after hook here:
# https://github.com/teamcapybara/capybara/blob/master/lib/capybara/rspec.rb
#
# Since Capybara is included before our rails_helper, the after block in the
# rspec setup is called before our rails_helper after block and the DOM is
# already reset prior to the after hook to take the screenshot.
#
# It's not pretty but I really wanted this functionality to exist
module Capybara
  # this is needed to call the original method that we are overwriting
  # it acts like super in this particular monkey patch
  singleton_class.send(:alias_method, :actual_reset_sessions!, :reset_sessions!)

  def self.reset_sessions!(fake: true)
    return if fake

    actual_reset_sessions!
  end
end
