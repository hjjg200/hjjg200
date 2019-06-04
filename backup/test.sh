#!/bin/bash

echo "argc is $#"
if [[ "$#" -eq 2 ]]; then
    echo "yes it is 2 args"
else
    echo "no it's not 2 args"
fi