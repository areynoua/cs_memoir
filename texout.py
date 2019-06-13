#!/usr/bin/python3

from sys import stdin

letters = 'abcdefghijklmnopqrstuvwxyz'

#def print(*w, **kw):
#    pass

def read() :
    try :
        r = stdin.read(1)
    except UnicodeDecodeError :
        print("ERROR in texout script")
        return ' '
    return r

def read_nonl() :
    c = stdin.read(1)
    while c == '\n' :
        c = stdin.read(1)
    return c

def push(c) :
    name = []
    ext = []
    c = read_nonl()
    while (len(ext) != 4 or c in letters) and c != ')' :
        if c not in letters :
            if len(ext) != 0 :
                name.extend(ext)
                ext = []
            if c == '.' :
                ext = ['.']
            else :
                name.append(c)
        else :
            if len(ext) not in (0,4) :
                ext.append(c)
            else :
                name.extend(ext)
                ext = []
                name.append(c)
        c = read_nonl()
    staged = ''.join(name+ext)

    if '/' not in staged or ' ' in staged and c == ')' :
        message('(' + staged + ')')
        return None
    else :
        print_messages()
        stack.append(staged)

    return c

def pop(c) :
    print_messages()
    try:
        stack.pop()
    except IndexError :
        print("ERROR in texout script")
    return None

def message(c) :
    messages.append(c)
    return None

def print_messages() :
    global messages, last_level_printed
    msg = ''.join(messages).strip()
    if len(msg) > 0 and not msg.isspace() :
        if len(stack) > 0 and last_level_printed != stack[-1] :
            last_level_printed = stack[-1]
            print('[94;1m', last_level_printed, '[39;0m:', sep='')
        msg = msg.replace('\n\n\n','\n\n').replace('\n.\n','.\n')
        for line in msg.splitlines() :
            if 'Warning' in line and not 'Package hyperref Warning: Token not allowed in a PDF string (Unicode):' in line :
                print('[91;1m', line, '[39;0m', sep='')
            elif 'TODO: ' in line[:7]:
                print('[92;1m', line, '[39;0m', sep='')
            else :
                print(line)
    elif len(stack) > 0 and last_level_printed != stack[-1] and stack[-1][0] == '.' :
            last_level_printed = stack[-1]
            print('[94;1m', last_level_printed, '[39;0m:', sep='')
    messages = []

messages = []
stack = []
last_level_printed = ''

actions = {
        '(' : push,
        ')' : pop,
        }

c = read()
while c != '' :
    c = actions.get(c, message)(c)
    while c != '' and c is not None :
        c = actions.get(c, message)(c)
    c = read()

print_messages()
