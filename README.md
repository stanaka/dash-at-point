# Overview

dash-at-point.el --- Search the word at point with Dash

[Dash](http://kapeli.com/) is an API Documentation Browser and Code Snippet Manager. dash-at-point make it easy to search the word at point with Dash.

# Usage

If you choose not to use one of the convenient packages in
[Melpa][melpa], you will need to add the directory containing
`dash-at-point.el` to your `load-path`, and then add the following to
your .emacs:

```
(add-to-list 'load-path "/path/to/dash-at-point")
(autoload 'dash-at-point "dash-at-point"
          "Search the word at point with Dash." t nil)
(global-set-key "\C-cd" 'dash-at-point)
```

Run `dash-at-point' to search the word at point, then Dash is launched and search the word.

Dash queries can be narrowed down with a docset prefix. You can customize the relations between docsets and major modes.

```
(add-to-list 'dash-at-point-mode-alist '(perl-mode . "perl"))
```

[melpa]: http://melpa.milkbox.net

# Copyright

Copyright (C) 2013 Shinji Tanaka

# Licence

This file is NOT part of GNU Emacs.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
