#!/usr/bin/env bash

set -e

# much wider format
#watch -n 30 'sinfo; squeue --format="%.18i %.9P %.30j %.8u %.8T %.10M %.9l %.6D %R"'

# shorter format
watch -n 30 'sinfo; squeue --format="%.6i %.9P %.30j %.8u %.8T %.10M %.9l %.6D %R"'
