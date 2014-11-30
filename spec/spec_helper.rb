# encoding: utf-8

gem 'rspec', '~> 3.1'
require 'rspec'
require 'codeclimate-test-reporter'
require 'trange_frange'

include TrangeFrange

CodeClimate::TestReporter.start
