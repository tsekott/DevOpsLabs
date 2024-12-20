#!/bin/bash

# Function to initiate a container on a designated CPU core
start_container() {
  name=$1
  core=$2
  # Verify if the container exists
  if docker ps -a --format '{{.Names}}' | grep -q "$name"; then
    # Remove the container if it is not running
    if ! docker ps --format '{{.Names}}' | grep -q "$name"; then
      docker rm "$name"
    else
      echo "Container $name is already running."
      return
    fi
  fi
  # Launch the container on the specified CPU core
  echo "Launching $name on core $core..."
  docker run -d --name "$name" --cpuset-cpus="$core" maryannna/httpserver
  sleep 10  # Allow time for the container to initialize
}

# Function to get the CPU usage of a container
fetch_cpu_usage() {
  name=$1
  # Retrieve the CPU usage percentage of the container
  docker stats "$name" --no-stream --format "{{.CPUPerc}}" | sed 's/%//'
}

# Function to update all active containers
refresh_containers() {
  echo "Pulling the latest image..."
  docker pull maryannna/httpserver

  # Assign container names to CPU cores
  declare -A cpu_map=( ["service1"]=0 ["service2"]=1 ["service3"]=2 )

  # Iterate through each container and refresh if it is running
  for name in service1 service2 service3; do
    if docker ps --format '{{.Names}}' | grep -q "$name"; then
      echo "Stopping $name for update..."
      docker stop "$name"
      docker rm "$name"
      echo "Restarting $name..."
      start_container "$name" "${cpu_map[$name]}"
    fi
  done
}

# Main loop logic
last_check=$(date +%s)
while true; do
  # Ensure service1 is running
  start_container service1 0
  echo "Checking service1..."
  if docker ps --format '{{.Names}}' | grep -q service1; then
    usage1=$(fetch_cpu_usage service1)
    sleep 20
    usage2=$(fetch_cpu_usage service1)
    # Check if service1 is heavily loaded
    if (( $(echo "$usage1 > 80" | bc -l) && $(echo "$usage2 > 80" | bc -l) )); then
      echo "service1 is heavily loaded for 2 consecutive checks. Checking service2..."
      # Start service2 if not running
      if ! docker ps --format '{{.Names}}' | grep -q service2; then
        start_container service2 1
      fi
    fi
  fi

  # Check service2 status
  if docker ps --format '{{.Names}}' | grep -q service2; then
    usage1=$(fetch_cpu_usage service2)
    sleep 20
    usage2=$(fetch_cpu_usage service2)
    # Check if service2 is heavily loaded
    if (( $(echo "$usage1 > 80" | bc -l) && $(echo "$usage2 > 80" | bc -l) )); then
      echo "service2 is heavily loaded for 2 consecutive checks. Checking service3..."
      # Start service3 if not running
      if ! docker ps --format '{{.Names}}' | grep -q service3; then
        start_container service3 2
      fi
    # Check if service2 is idle
    elif (( $(echo "$usage1 < 10" | bc -l) && $(echo "$usage2 < 10" | bc -l) )); then
      echo "service2 is idle for 2 consecutive checks. Stopping it..."
      docker stop service2
      docker rm service2
    fi
  fi

  # Check service3 status
  if docker ps --format '{{.Names}}' | grep -q service3; then
    usage1=$(fetch_cpu_usage service3)
    sleep 20
    usage2=$(fetch_cpu_usage service3)
    # Check if service3 is idle
    if (( $(echo "$usage1 < 10" | bc -l) && $(echo "$usage2 < 10" | bc -l) )); then
      echo "service3 is idle for 2 consecutive checks. Stopping it..."
      docker stop service3
      docker rm service3
    fi
  fi

  # Check for new image version every 10 minutes
  current_time=$(date +%s)
  if (( current_time - last_check >= 600 )); then
    echo "Checking for new image version..."
    if docker pull maryannna/httpserver | grep -q 'Downloaded newer image'; then
      echo "New image version detected. Updating containers..."
      declare -A cpu_map=( ["service1"]=0 ["service2"]=1 ["service3"]=2 )
      # Update each running container
      for name in service1 service2 service3; do
        if docker ps --format '{{.Names}}' | grep -q "$name"; then
          echo "Updating $name..."
          docker stop "$name"
          docker rm "$name"
          start_container "$name" "${cpu_map[$name]}"
          sleep 10  # Ensure at least one container is active before updating the next
        fi
      done
    fi
    last_check=$current_time
  fi

  sleep 20
done