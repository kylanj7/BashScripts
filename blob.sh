# Move all files into parent directory, remove all child directories
find . -mindepth 2 -type f -exec mv -n -t "<DIRNAME>" {} +
