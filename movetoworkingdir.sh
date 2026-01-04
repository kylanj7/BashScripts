#!/bin/bash
# moves all files into the working directory from the nested directories 
find . -type f -exec mv {} . \;
