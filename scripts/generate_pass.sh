#!/bin/bash

# Length of the password
PASSWORD_LENGTH=8

# Generate password using /dev/urandom and tr to filter characters
PASSWORD=$(tr -dc 'A-Za-z0-9!@#$%&*()-_=+[]{}' < /dev/urandom | head -c "$PASSWORD_LENGTH")

echo "Generated Password: $PASSWORD"
