;; dash-at-point.el --- Search the word at point with Dash

;; Copyright (C) 2013 Shinji Tanaka
;; Author:  Shinji Tanaka <shinji.tanaka@gmail.com>
;; Created: 17 Feb 2013
;; Version: 0.0.3
;; URL: https://github.com/stanaka/dash-at-point
;;
;; This file is NOT part of GNU Emacs.
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy of
;; this software and associated documentation files (the "Software"), to deal in
;; the Software without restriction, including without limitation the rights to
;; use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is furnished to do
;; so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.
;;
;;; Commentary:
;;
;; Dash ( http://kapeli.com/ ) is an API Documentation Browser and
;; Code Snippet Manager. dash-at-point make it easy to search the word
;; at point with Dash.
;;
;; Add the following to your .emacs:
;;
;;   (add-to-list 'load-path "/path/to/dash-at-point")
;;   (autoload 'dash-at-point "dash-at-point"
;;             "Search the word at point with Dash." t nil)
;;   (global-set-key "\C-cd" 'dash-at-point)
;;
;; Run `dash-at-point' to search the word at point, then Dash is
;; launched and search the word.
;;
;; Dash queries can be narrowed down with a docset prefix. You can
;; customize the relations between docsets and major modes.
;;
;;   (add-to-list 'dash-at-point-mode-alist '(perl-mode . "perl"))

;;; Code:

(defvar dash-at-point-mode-alist
  '(
    (c-mode . "c")
    (c++-mode . "cpp")
    (css-mode . "css")
    (emacs-lisp-mode . "elisp")
    (html-mode . "html")
    (java-mode . "java")
    (js2-mode . "javascript")
    (lua-mode . "lua")
    (objc-mode . "iphoneos")
    (perl-mode . "perl")
    (cperl-mode . "perl")
    (php-mode . "php")
    (python-mode . "python3")
    (ruby-mode . "ruby")
    (scala-mode . "scala")
    (vim-mode . "vim")
    )
  "Association list of Language strings and major-modes.")

(defun dash-at-point-guess-docset ()
  "Guess which docset suit to the current major mode."
  (cdr (assoc major-mode dash-at-point-mode-alist))
)

(defun dash-at-point ()
  "Call Dash the word at point."
  (interactive)
  (start-process 
   "Dash" nil "open" 
   (concat 
    "dash://" 
    (read-from-minibuffer
     "Dash search: "
     (if (dash-at-point-guess-docset)
	 (concat
	  (dash-at-point-guess-docset) ":"
	  (thing-at-point 'symbol))
       (thing-at-point 'symbol))
     )))
)

(provide 'dash-at-point)

;;; dash-at-point.el ends here
