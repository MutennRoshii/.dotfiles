#!/bin/bash

FIRST_WORKSPACE=1
LAST_WORKSPACE=10

function get_focused_workspace() {
    i3-msg -t get_workspaces | jq '.[] | select(.focused).num'
}

function get_workspace_count() {
    i3-msg -t get_workspaces | jq '. | length'
}

function get_workspaces() {
    i3-msg -t get_workspaces | jq '.[] | .num'
}

function swipe_next_workspace() {
    current_workspace=$(get_focused_workspace)
    if [ $current_workspace -eq $LAST_WORKSPACE ]; then
	return
    fi
    if [ $current_workspace -eq $(get_workspaces | tail -n 1) ]; then
	next_workspace=$((current_workspace + 1))
	exec i3-msg workspace $next_workspace
	return
    fi
    exec i3-msg workspace next
}

function swipe_prev_workspace() {
    current_workspace=$(get_focused_workspace)
    if [ $current_workspace -eq $FIRST_WORKSPACE ]; then
	return
    fi
    if [ $current_workspace -eq $(get_workspaces | head -n 1) ]; then
	prev_workspace=$((current_workspace - 1))
	exec i3-msg workspace $prev_workspace
	return
    fi
    exec i3-msg workspace prev
}

case $1 in
"next")
    swipe_next_workspace
    ;;
"prev")
    swipe_prev_workspace
    ;;
*)
    echo "Usage: swipe-workspace.sh [next|prev]"
    ;;
esac

