#!/bin/bash

var1="this
is a
multiline
variable"

echo echo
echo "$var1" | wc -l
echo printf
printf "$var1" | wc -l
