# A sample Gemfile
source "https://rubygems.org"

gem 'fastlane'
gem "activesupport", "= 7.0.8"
gem "concurrent-ruby", "= 1.3.4"
gem "cocoapods"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
