#!/usr/bin/env bash

port selfupdate
port reclaim
port upgrade outdated
port reclaim
port diagnose --quiet
