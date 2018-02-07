#!/usr/bin/env bash
bundle check || bundle install
ruby generate.rb