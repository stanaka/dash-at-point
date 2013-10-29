;;; dash-at-point.el --- Search the word at point with Dash

;; Copyright (C) 2013 Shinji Tanaka
;; Author:  Shinji Tanaka <shinji.tanaka@gmail.com>
;; Created: 17 Feb 2013
;; Version: 0.0.4
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
;; Code Snippet Manager.  dash-at-point make it easy to search the word
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
;; launched and search the word. To edit the search term first,
;; use C-u to set the prefix argument for `dash-at-point'.
;;
;; Dash queries can be narrowed down with a docset prefix.  You can
;; customize the relations between docsets and major modes.
;;
;;   (add-to-list 'dash-at-point-mode-alist '(perl-mode . "perl"))
;;
;; Additionally, the buffer-local variable `dash-at-point-docset' can
;; be set in a specific mode hook (or file/directory local variables)
;; to programmatically override the guessed docset.  For example:
;;
;;   (add-hook 'rinari-minor-mode-hook
;;             (lambda () (setq dash-at-point-docset "rails")))

;;; Code:

;;;###autoload
(defgroup dash-at-point nil
  "Searching in Dash for text at point."
  :prefix "dash-at-point-"
  :group 'external)

;;;###autoload
(defcustom dash-at-point-mode-alist
  '((c++-mode . "cpp")
    (c-mode . "c")
    (clojure-mode . "clojure")
    (coffee-mode . "coffee")
    (common-lisp-mode . "lisp")
    (cperl-mode . "perl")
    (css-mode . "css")
    (elixir-mode . "elixir")
    (emacs-lisp-mode . "elisp")
    (erlang-mode . "erlang")
    (gfm-mode . "markdown")
    (go-mode . "go")
    (groovy-mode . "groovy")
    (haskell-mode . "haskell")
    (html-mode . "html")
    (java-mode . "java")
    (js2-mode . "javascript")
    (js3-mode . "nodejs")
    (less-css-mode . "less")
    (lua-mode . "lua")
    (markdown-mode . "markdown")
    (objc-mode . "iphoneos")
    (perl-mode . "perl")
    (php-mode . "php")
    (processing-mode . "processing")
    (puppet-mode . "puppet")
    (python-mode . "python3")
    (ruby-mode . "ruby")
    (sass-mode . "sass")
    (scala-mode . "scala")
    (vim-mode . "vim"))
  "Alist which maps major modes to Dash docset tags.
Each entry is of the form (MAJOR-MODE . DOCSET-TAG) where
MAJOR-MODE is a symbol and DOCSET-TAG is a corresponding tag
for one or more docsets in Dash."
  :type '(repeat (cons (symbol :tag "Major mode name")
                       (string :tag "Docset tag")))
  :group 'dash-at-point)

;;;###autoload
(defvar dash-at-point-docsets (mapcar
                               (lambda (element)
                                 (cdr element))
                               dash-at-point-mode-alist)
  "Variable used to store all known Dash docsets. The default value
is a collection of all the values from `dash-at-point-mode-alist'.

Setting or appending this variable can be used to add completion
options to `dash-at-point-with-docset'.")

;;;###autoload
(defvar dash-at-point-docset nil
  "Variable used to specify the docset for the current buffer.
Users can set this to override the default guess made using
`dash-at-point-mode-alist', allowing the docset to be determined
programatically.

For example, Ruby on Rails programmers might add an \"allruby\"
tag to the Rails, Ruby and Rubygems docsets in Dash, and then add
code to `rinari-minor-mode-hook' or `ruby-on-rails-mode-hook'
which sets this variable to \"allruby\" so that Dash will search
the combined docset.")
(make-variable-buffer-local 'dash-at-point-docset)

(defun dash-at-point-guess-docset ()
  "Guess which docset suit to the current major mode."
  (cdr (assoc major-mode dash-at-point-mode-alist)))

(defun dash-at-point-run-search (search-string)
  "Directly execute search for SEARCH-STRING in Dash."
  (start-process "Dash" nil "open" (concat "dash://" search-string)))

(defun dash-at-point-maybe-add-docset (search-string)
  "Prefix SEARCH-STRING with the guessed docset, if any."
  (let ((docset (or dash-at-point-docset (dash-at-point-guess-docset))))
    (concat (when docset
              (concat docset ":"))
            search-string)))

;;;###autoload
(defun dash-at-point (&optional edit-search)
  "Search for the word at point in Dash.
If the optional prefix argument EDIT-SEARCH is specified,
the user will be prompted to edit the search string first."
  (interactive "P")
  (let* ((thing (thing-at-point 'symbol))
         (search (dash-at-point-maybe-add-docset thing)))
    (dash-at-point-run-search
     (if (or edit-search (null thing))
         (read-string "Dash search: " search)
       search))))

;;;###autoload
(defun dash-at-point-with-docset (&optional edit-search)
  "Search for the word at point in Dash with a chosen docset.
The docset options are suggested from the variable
`dash-at-point-docsets'.

If the optional prefix argument EDIT-SEARCH is specified,
the user will be prompted to edit the search string after
choosing the docset."
  (interactive "P")
  (let* ((thing (thing-at-point 'symbol))
         (docset (completing-read "Dash docset: " dash-at-point-docsets))
         (search (if (or edit-search (null thing))
                     (read-from-minibuffer (concat "Dash search (" docset "): "))
                   thing)))
    (dash-at-point-run-search
     (concat docset ":" search))))

(provide 'dash-at-point)

;;; dash-at-point.el ends here
