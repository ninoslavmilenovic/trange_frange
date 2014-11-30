# encoding: utf-8

gem 'rspec', '~> 3.1'
require 'rspec'
require 'codeclimate-test-reporter'
require 'trange_frange'

include TrangeFrange

ENV['CODECLIMATE_REPO_TOKEN'] = '5dd60a5cd7798f1af725393701b267e5b4366c7ef895c6643746735c5645ef91'
CodeClimate::TestReporter.start
