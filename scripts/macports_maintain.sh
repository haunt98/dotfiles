#!/usr/bin/env bash

port selfupdate
port upgrade outdated
port reclaim
port diagnose --quiet
