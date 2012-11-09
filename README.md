hablog
======

A simple static blog generator.

When run, Hablog searches the current directory for a file named "index", which is expected to contain a newline-delimited list of file names. Each file represents one blog entry. Each of these files is expected to contain a title on the first line, and the remainder of the file is expected to contain the HTML-formatted blog entry.

Hablog creates a directory named "output", and writes an HTML blog into this directory. An index.html file will contain a list of all blog entries, and each blog entry will be outfitted with "previous" and "next" links.

Note that all the CSS and HTML headers are currently hard-coded into hablog.hs. Future versions of Hablog may feature some kind of templating engine instead.
