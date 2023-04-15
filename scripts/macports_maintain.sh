#!/usr/bin/env bash

port selfupdate
port reclaim
port outdated
port upgrade outdated
port reclaim
port diagnose --quiet
