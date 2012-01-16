#!/usr/bin/env python
''' Script to do very basic conversion of TRAC to reST format '''

import sys
import re

rst_section_levels = ['*', '=', '-', '~', '^']
heading_re = re.compile('^(=+) +([^=]+) +(=+)')
enumerate_re = re.compile(r'^ +(\d+[\)\.]) +(.*)')
link_re = re.compile(r'\[+ *(https?://[\w.\-~/\?=]+) +(.+?) *\]+')
wiki_link_re = re.compile(r'\[+ *wiki:(\w+) +(.+?) *\]+') # [wiki:GoToPage go to page]
wiki_link_simple_re = re.compile(r'\[+ *wiki:(\w+) *\]+') # [wiki:GoToPage]
image_re = re.compile(r'\[\[ *Image\( *(.+) *\) *\]+') # [[Image(example.png)]]
italic_re = re.compile(r"'''(.+?)'''")
bold_re = re.compile(r"''(.+?)''")
inpre_re = re.compile(r"{{{(.+?)}}}")
outprestart_re = re.compile(r"^ *{{{ *$")
outprestop_re = re.compile(r"^ *}}} *$")
define_re = re.compile("^([^ ])(.*?)::")


class state_object(object):
    def __init__(self, lines, indent='', dialect='ReST'):
        self.lines = lines
        self.indent = indent
        self.dialect = dialect

    def add_line(self, line):
        self.lines.append(self.indent+line)

    def __call__(self, line):
        raise NotImplementedError

    def __iter__(self):
        for line in self.lines:
            yield line


class preformatted_state(state_object):
    ''' State function for within preformatted blocks '''
    def __call__(self, line):
        if outprestop_re.match(line):
            self.add_line('')
            return standard_state(self.lines, dialect=self.dialect)
        self.add_line('   ' + line)
        return self


def std_subs(line, dialect):
    ''' standard in-line substitutions '''
    line = link_re.sub(r'`\2 <\1>`_', line)
    line = italic_re.sub(r'*\1*', line)
    line = bold_re.sub(r'**\1**', line)
    line = inpre_re.sub(r'``\1``', line)
    if dialect == 'gollum':
        # gollum specific
        line = wiki_link_re.sub(r'[[\2|\1]]', line)
        line = wiki_link_simple_re.sub(r'[[\1]]', line)
        line = image_re.sub(r'[[\1]]', line)
    else:
        line = wiki_link_re.sub(r'`\2 <\1>`_', line)
        line = wiki_link_simple_re.sub(r'`\1 <\1>`_', line)
        line = image_re.sub(r'.. image:: \1', line)
    return line


class standard_state(state_object):
    def __call__(self, line):
        ''' State function for within normal text '''
        # beginning preformat block?
        if outprestart_re.match(line):
            self.add_line('::')
            self.add_line('')
            return preformatted_state(self.lines, dialect=self.dialect)
        # Heading
        hmatch = heading_re.match(line)
        if hmatch:
            eq1, heading, eq2 = hmatch.groups()
            if len(eq1) == len(eq2):
                self.add_line(heading)
                self.add_line(rst_section_levels[len(eq1)] * len(heading))
                return self
        if line.startswith(' *') or line.startswith(' -'):
            line = line[1:]
        line = enumerate_re.sub(r'#. \2', line)
        line = define_re.sub(r'\1\2', line)
        line = std_subs(line, self.dialect)
        self.add_line(line)
        return self


def trac2rst(linesource, dialect='ReST'):
    ''' Process trac line source

    A simple finite state machine

    >>> lines = ['Hello', '= Heading1 =', '=Heading2=', '== Heading 3 ==']
    >>> trac2rst(lines)
    ['Hello', 'Heading1', '========', '=Heading2=', 'Heading 3', '---------']
    >>> trac2rst([' * bullet point'])
    ['* bullet point']
    >>> trac2rst([' 33 not numbered'])
    [' 33 not numbered']
    >>> trac2rst([' 33) numbered'])
    ['#. numbered']
    >>> trac2rst(['some text then [http://www.python.org/doc a link], then text'])
    ['some text then `a link <http://www.python.org/doc>`_, then text']
    >>> line = 'text [http://www.python.org python] ' + \
               'text [http://www.scipy.org scipy] '
    >>> trac2rst([line])
    ['text `python <http://www.python.org>`_ text `scipy <http://www.scipy.org>`_']
    >>> # The next line conceals the triple quotes from the docstring parser
    >>> trac2rst([r"Some %sitalic%s text, then %smore%s" % (("'"*3,) * 4)])
    ['Some *italic* text, then *more*']
    >>> trac2rst([r"Some ''bold'' text, then ''more''"])
    ['Some **bold** text, then **more**']
    >>> # inline preformatted text
    >>> trac2rst(['here is some {{{preformatted text}}} (end)'])
    ['here is some ``preformatted text`` (end)']
    >>> # multiline preformatted
    >>> trac2rst(['','{{{','= preformatted =', ' * text', '}}}'])
    ['', '::', '', '   = preformatted =', '    * text', '']
    >>> # define
    >>> trac2rst(['a definition::', '  some explanation'])
    ['a definition', '  some explanation']
    '''
    processor = standard_state([], dialect=dialect)
    for line in linesource:
        line = line.rstrip()
        processor = processor(line)
    return processor.lines


if __name__ == '__main__':
    try:
        infile = sys.argv[1]
    except IndexError:
        raise OSError('Need input file')
    lines = trac2rst(file(infile))
    print '\n'.join(lines)
