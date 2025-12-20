"""
Pipeline Description:
'find .' - This searching the current directory with "." representing the current directory
'-name *.py' - Find all files that match the pattern *.py (all Python files)
'-exec' -exec - Execute a command for each file found
'sed -i '1i #!/usr/bin/env python3'' - The sed command that modifies the file
    - sed = Stream editor for text manipulation
    - -i = Edit files "in-place" (modify the original file directly)
    - '1i #!/usr/bin/env python3' = Insert (i) at line 1 the shebang text
'{}' - Placeholder that gets replaced with each filename found
'+' - Batch multiple files together in a single sed call
"""

find . -name "*.py" -exec sed -i '1s|^|#!/usr/bin/env python3\n|' {} +
