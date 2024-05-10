#!/usr/bin/env bash

rye self update

rye tools list | xargs -L1 rye install --force
