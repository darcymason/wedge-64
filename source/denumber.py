# renumber.py
usage = """
python denumber.py filename

The original file is overwritten with the line numbers removed.
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


def denumber_text(text):
    # keep running output lines
    output = []

    for line in text.splitlines():
        if line.strip():
            line_num, rest = line.split(" ", 1)
            output.append(rest)
        else:
            output.append("")

    return "\n".join(output)


def main():
    import sys

    if len(sys.argv) < 2:
        print(usage)
        sys.exit(-1)

    filename = sys.argv[1]
    with open(filename, 'r') as f:
        orig = f.read()

    new_text = denumber_text(orig)

    with open(filename, 'w') as f:
        f.write(new_text)


if __name__ == "__main__":
    main()
    # test()
