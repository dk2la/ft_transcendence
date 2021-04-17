#!/bin/bash

# Set activity monitoring error
set -e

# Take needs directory
cd /tabletennis

# Drop old db
./bin/rails db:drop

# Create new db
./bin/rails db:create

# Migrate models tables to new db
./bin/rails db:migrate

./bin/rails server -b 0.0.0.0