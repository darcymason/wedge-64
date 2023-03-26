# renumber.py
usage = """
python renumber.py filename old_line_num new_line_num [increment]

where old_line_num is the first line number to change
and new_line_num is its new value
all subsequent lines are `increment` more than the previous (default 10)

The original file is overwritten with the new line numbers
"""

def num_split(line):
    try:
        line_num, rest = line.split(" ", 1)
    except ValueError:
        line_num = None
        rest = None
    else:
        try:
            line_num = int(line_num)
        except ValueError:
            line_num = None
    return line_num, rest


def renumber_text(text, old_line_num, new_line_num, increment):
    current_line_num = new_line_num
    increment = int(increment)
    old_line_num = str(old_line_num)

    # keep running output lines
    output = []

    # Find start point where we will start renumbering:
    iter_lines = iter(text.splitlines())
    line = next(iter_lines)

    while not line.startswith(old_line_num):
        output.append(line)
        line = next(iter_lines)

    # Replace the line with the starting number
    line_num, rest = line.split(" ", 1)
    output.append(str(new_line_num) + " " + rest)

    # Now renumber the rest using the increment, except 50000 link to next file
    for line in iter_lines:
        current_line_num = int(current_line_num) + increment
        num, rest = line.split(" ", 1)
        if num == "50000":
            output.append(line)
        else:
            output.append(str(current_line_num) + " " + rest)

    return "\n".join(output)


def main():
    import sys

    if len(sys.argv) < 3:
        print(usage)
        sys.exit(-1)

    increment = sys.argv[4] if len(sys.argv)>4 else 10
    filename, old_line_num, new_line_num = sys.argv[1:4]

    with open(filename, 'r') as f:
        orig = f.read()

    new_text = renumber_text(orig, old_line_num, new_line_num, increment)

    with open(filename, 'w') as f:
        f.write(new_text)


def test():
    import textwrap
    text = textwrap.dedent("""\
        100 Line 100
        104 Line 104
        106 Line 106
        110 Line 110 -> 210
        111 Line 111 -> 220
        220 Line 220 -> 230
        50000 Keep 50000
        """
    )
    new_text = renumber_text(text, 110, 210, 10)
    print(new_text)


if __name__ == "__main__":
    main()
    # test()
