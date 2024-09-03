#!/usr/bin/env bash

bun upgrade --stable
bun outdated --global

bun update --global --latest prettier
