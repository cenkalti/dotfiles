<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<!-- Created by htmlize-1.34 in css mode. -->
<html>
  <head>
    <title>php-mode.el</title>
    <style type="text/css">
    <!--
      body {
        color: #000000;
        background-color: #ffffff;
      }
      .builtin {
        /* font-lock-builtin-face */
        color: #da70d6;
      }
      .comment {
        /* font-lock-comment-face */
        color: #b22222;
      }
      .comment-delimiter {
        /* font-lock-comment-delimiter-face */
        color: #b22222;
      }
      .constant {
        /* font-lock-constant-face */
        color: #5f9ea0;
      }
      .doc {
        /* font-lock-doc-face */
        color: #bc8f8f;
      }
      .function-name {
        /* font-lock-function-name-face */
        color: #0000ff;
      }
      .keyword {
        /* font-lock-keyword-face */
        color: #a020f0;
      }
      .negation-char {
      }
      .regexp-grouping-backslash {
        /* font-lock-regexp-grouping-backslash */
        font-weight: bold;
      }
      .regexp-grouping-construct {
        /* font-lock-regexp-grouping-construct */
        font-weight: bold;
      }
      .string {
        /* font-lock-string-face */
        color: #bc8f8f;
      }
      .type {
        /* font-lock-type-face */
        color: #228b22;
      }
      .variable-name {
        /* font-lock-variable-name-face */
        color: #b8860b;
      }
      .warning {
        /* font-lock-warning-face */
        color: #ff0000;
        font-weight: bold;
      }

      a {
        color: inherit;
        background-color: inherit;
        font: inherit;
        text-decoration: inherit;
      }
      a:hover {
        text-decoration: underline;
      }
    -->
    </style>
  </head>
  <body>
    <pre>
<span class="comment-delimiter">;;; </span><span class="comment">php-mode.el --- major mode for editing PHP code
</span>
<span class="comment-delimiter">;; </span><span class="comment">Copyright (C) 1999, 2000, 2001, 2003, 2004 Turadg Aleahmad
</span><span class="comment-delimiter">;;               </span><span class="comment">2008 Aaron S. Hawley
</span>
<span class="comment-delimiter">;; </span><span class="comment">Maintainer: Aaron S. Hawley &lt;ashawley at users.sourceforge.net&gt;
</span><span class="comment-delimiter">;; </span><span class="comment">Author: Turadg Aleahmad, 1999-2004
</span><span class="comment-delimiter">;; </span><span class="comment">Keywords: php languages oop
</span><span class="comment-delimiter">;; </span><span class="comment">Created: 1999-05-17
</span><span class="comment-delimiter">;; </span><span class="comment">Modified: 2008-11-04
</span><span class="comment-delimiter">;; </span><span class="comment">X-URL:   http://php-mode.sourceforge.net/
</span>
(<span class="keyword">defconst</span> <span class="variable-name">php-mode-version-number</span> <span class="string">"1.5.0"</span>
  <span class="doc">"PHP Mode version number."</span>)

<span class="comment-delimiter">;;; </span><span class="comment">License
</span>
<span class="comment-delimiter">;; </span><span class="comment">This file is free software; you can redistribute it and/or
</span><span class="comment-delimiter">;; </span><span class="comment">modify it under the terms of the GNU General Public License
</span><span class="comment-delimiter">;; </span><span class="comment">as published by the Free Software Foundation; either version 3
</span><span class="comment-delimiter">;; </span><span class="comment">of the License, or (at your option) any later version.
</span>
<span class="comment-delimiter">;; </span><span class="comment">This file is distributed in the hope that it will be useful,
</span><span class="comment-delimiter">;; </span><span class="comment">but WITHOUT ANY WARRANTY; without even the implied warranty of
</span><span class="comment-delimiter">;; </span><span class="comment">MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
</span><span class="comment-delimiter">;; </span><span class="comment">GNU General Public License for more details.
</span>
<span class="comment-delimiter">;; </span><span class="comment">You should have received a copy of the GNU General Public License
</span><span class="comment-delimiter">;; </span><span class="comment">along with this file; if not, write to the Free Software
</span><span class="comment-delimiter">;; </span><span class="comment">Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
</span><span class="comment-delimiter">;; </span><span class="comment">02110-1301, USA.
</span>
<span class="comment-delimiter">;;; </span><span class="comment">Usage
</span>
<span class="comment-delimiter">;; </span><span class="comment">Put this file in your Emacs lisp path (eg. site-lisp) and add to
</span><span class="comment-delimiter">;; </span><span class="comment">your .emacs file:
</span><span class="comment-delimiter">;;</span><span class="comment">
</span><span class="comment-delimiter">;;   </span><span class="comment">(require 'php-mode)
</span>
<span class="comment-delimiter">;; </span><span class="comment">To use abbrev-mode, add lines like this:
</span><span class="comment-delimiter">;;   </span><span class="comment">(add-hook 'php-mode-hook
</span><span class="comment-delimiter">;;     </span><span class="comment">'(lambda () (define-abbrev php-mode-abbrev-table "ex" "extends")))
</span>
<span class="comment-delimiter">;; </span><span class="comment">To make php-mode compatible with html-mode, see http://php-mode.sf.net
</span>
<span class="comment-delimiter">;; </span><span class="comment">Many options available under Help:Customize
</span><span class="comment-delimiter">;; </span><span class="comment">Options specific to php-mode are in
</span><span class="comment-delimiter">;;  </span><span class="comment">Programming/Languages/Php
</span><span class="comment-delimiter">;; </span><span class="comment">Since it inherits much functionality from c-mode, look there too
</span><span class="comment-delimiter">;;  </span><span class="comment">Programming/Languages/C
</span>
<span class="comment-delimiter">;;; </span><span class="comment">Commentary:
</span>
<span class="comment-delimiter">;; </span><span class="comment">PHP mode is a major mode for editing PHP 3 and 4 source code.  It's
</span><span class="comment-delimiter">;; </span><span class="comment">an extension of C mode; thus it inherits all C mode's navigation
</span><span class="comment-delimiter">;; </span><span class="comment">functionality.  But it colors according to the PHP grammar and indents
</span><span class="comment-delimiter">;; </span><span class="comment">according to the PEAR coding guidelines.  It also includes a couple
</span><span class="comment-delimiter">;; </span><span class="comment">handy IDE-type features such as documentation search and a source
</span><span class="comment-delimiter">;; </span><span class="comment">and class browser.
</span>
<span class="comment-delimiter">;;; </span><span class="comment">Contributors: (in chronological order)
</span>
<span class="comment-delimiter">;; </span><span class="comment">Juanjo, Torsten Martinsen, Vinai Kopp, Sean Champ, Doug Marcey,
</span><span class="comment-delimiter">;; </span><span class="comment">Kevin Blake, Rex McMaster, Mathias Meyer, Boris Folgmann, Roland
</span><span class="comment-delimiter">;; </span><span class="comment">Rosenfeld, Fred Yankowski, Craig Andrews, John Keller, Ryan
</span><span class="comment-delimiter">;; </span><span class="comment">Sammartino, ppercot, Valentin Funk, Stig Bakken, Gregory Stark,
</span><span class="comment-delimiter">;; </span><span class="comment">Chris Morris, Nils Rennebarth, Gerrit Riessen, Eric Mc Sween,
</span><span class="comment-delimiter">;; </span><span class="comment">Ville Skytta, Giacomo Tesio, Lennart Borgman, Stefan Monnier,
</span><span class="comment-delimiter">;; </span><span class="comment">Aaron S. Hawley, Ian Eure, Bill Lovett, Dias Badekas, David House
</span>
<span class="comment-delimiter">;;; </span><span class="comment">Changelog:
</span>
<span class="comment-delimiter">;; </span><span class="comment">1.5
</span><span class="comment-delimiter">;;   </span><span class="comment">Support function keywords like public, private and the ampersand
</span><span class="comment-delimiter">;;   </span><span class="comment">character for function-based commands.  Support abstract, final,
</span><span class="comment-delimiter">;;   </span><span class="comment">static, public, private and protected keywords in Imenu.  Fix
</span><span class="comment-delimiter">;;   </span><span class="comment">reversed order of Imenu entries.  Use font-lock-preprocessor-face
</span><span class="comment-delimiter">;;   </span><span class="comment">for PHP and ASP tags.  Make php-mode-modified a literal value
</span><span class="comment-delimiter">;;   </span><span class="comment">rather than a computed string.  Add date and time constants of
</span><span class="comment-delimiter">;;   </span><span class="comment">PHP. (Dias Badekas) Fix false syntax highlighting of keywords
</span><span class="comment-delimiter">;;   </span><span class="comment">because of underscore character.  Change HTML indentation warning
</span><span class="comment-delimiter">;;   </span><span class="comment">to match only HTML at the beginning of the line.  Fix
</span><span class="comment-delimiter">;;   </span><span class="comment">byte-compiler warnings.  Clean-up whitespace and audited style
</span><span class="comment-delimiter">;;   </span><span class="comment">consistency of code.  Remove conditional bindings and XEmacs code
</span><span class="comment-delimiter">;;   </span><span class="comment">that likely does nothing.
</span><span class="comment-delimiter">;;</span><span class="comment">
</span><span class="comment-delimiter">;; </span><span class="comment">1.4
</span><span class="comment-delimiter">;;   </span><span class="comment">Updated GNU GPL to version 3.  Ported to Emacs 22 (CC mode
</span><span class="comment-delimiter">;;   </span><span class="comment">5.31). M-x php-mode-version shows version.  Provide end-of-defun
</span><span class="comment-delimiter">;;   </span><span class="comment">beginning-of-defun functionality. Support add-log library.
</span><span class="comment-delimiter">;;   </span><span class="comment">Fix __CLASS__ constant (Ian Eure).  Allow imenu to see visibility
</span><span class="comment-delimiter">;;   </span><span class="comment">declarations -- "private", "public", "protected". (Bill Lovett)
</span><span class="comment-delimiter">;;</span><span class="comment">
</span><span class="comment-delimiter">;; </span><span class="comment">1.3
</span><span class="comment-delimiter">;;   </span><span class="comment">Changed the definition of # using a tip from Stefan
</span><span class="comment-delimiter">;;   </span><span class="comment">Monnier to correct highlighting and indentation. (Lennart Borgman)
</span><span class="comment-delimiter">;;   </span><span class="comment">Changed the highlighting of the HTML part. (Lennart Borgman)
</span><span class="comment-delimiter">;;</span><span class="comment">
</span><span class="comment-delimiter">;; </span><span class="comment">See the ChangeLog file included with the source package.
</span>

<span class="comment-delimiter">;;; </span><span class="comment">Code:
</span>
(<span class="keyword">require</span> '<span class="constant">speedbar</span>)
(<span class="keyword">require</span> '<span class="constant">font-lock</span>)
(<span class="keyword">require</span> '<span class="constant">cc-mode</span>)
(<span class="keyword">require</span> '<span class="constant">cc-langs</span>)
(<span class="keyword">require</span> '<span class="constant">custom</span>)
(<span class="keyword">require</span> '<span class="constant">etags</span>)
(<span class="keyword">eval-when-compile</span>
  (<span class="keyword">require</span> '<span class="constant">regexp-opt</span>))</pre><hr /><pre>
<span class="comment-delimiter">;; </span><span class="comment">Local variables
</span>(<span class="keyword">defgroup</span> <span class="type">php</span> nil
  <span class="doc">"Major mode `</span><span class="doc"><span class="constant">php-mode</span></span><span class="doc">' for editing PHP code."</span>
  <span class="builtin">:prefix</span> <span class="string">"php-"</span>
  <span class="builtin">:group</span> 'languages)

(<span class="keyword">defcustom</span> <span class="variable-name">php-default-face</span> 'default
  <span class="doc">"Default face in `</span><span class="doc"><span class="constant">php-mode</span></span><span class="doc">' buffers."</span>
  <span class="builtin">:type</span> 'face
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defcustom</span> <span class="variable-name">php-speedbar-config</span> t
  <span class="doc">"When set to true automatically configures Speedbar to observe PHP files.
Ignores php-file patterns option; fixed to expression \"\\.\\(inc\\|php[s34]?\\)\""</span>
  <span class="builtin">:type</span> 'boolean
  <span class="builtin">:set</span> (<span class="keyword">lambda</span> (sym val)
         (set-default sym val)
         (<span class="keyword">if</span> (and val (boundp 'speedbar))
             (speedbar-add-supported-extension
              <span class="string">"\\.</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">inc</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">php[s34]?</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">phtml</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">"</span>)))
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defcustom</span> <span class="variable-name">php-mode-speedbar-open</span> nil
  <span class="doc">"Normally `</span><span class="doc"><span class="constant">php-mode</span></span><span class="doc">' starts with the speedbar closed.
Turning this on will open it whenever `</span><span class="doc"><span class="constant">php-mode</span></span><span class="doc">' is loaded."</span>
  <span class="builtin">:type</span> 'boolean
  <span class="builtin">:set</span> (<span class="keyword">lambda</span> (sym val)
         (set-default sym val)
         (<span class="keyword">when</span> val
           (speedbar 1)))
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defvar</span> <span class="variable-name">php-imenu-generic-expression</span>
  '(
    (<span class="string">"Private Methods"</span>
     <span class="string">"^\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">abstract</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">final</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?private\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">static\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?function\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*("</span> 1)
    (<span class="string">"Protected Methods"</span>
     <span class="string">"^\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">abstract</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">final</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?protected\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">static\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?function\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*("</span> 1)
    (<span class="string">"Public Methods"</span>
     <span class="string">"^\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">abstract</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">final</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?public\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">static\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?function\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*("</span> 1)
    (<span class="string">"Classes"</span>
     <span class="string">"^\\s-*class\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*"</span> 1)
    (<span class="string">"All Functions"</span>
     <span class="string">"^\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">abstract</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">final</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">private</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">protected</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">public</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">static</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">*function\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*("</span> 1)
    )
  <span class="doc">"Imenu generic expression for PHP Mode.  See `</span><span class="doc"><span class="constant">imenu-generic-expression</span></span><span class="doc">'."</span>
  )

(<span class="keyword">defcustom</span> <span class="variable-name">php-manual-url</span> <span class="string">"http://www.php.net/manual/en/"</span>
  <span class="doc">"URL at which to find PHP manual.
You can replace \"en\" with your ISO language code."</span>
  <span class="builtin">:type</span> 'string
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defcustom</span> <span class="variable-name">php-search-url</span> <span class="string">"http://www.php.net/"</span>
  <span class="doc">"URL at which to search for documentation on a word."</span>
  <span class="builtin">:type</span> 'string
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defcustom</span> <span class="variable-name">php-completion-file</span> <span class="string">""</span>
  <span class="doc">"Path to the file which contains the function names known to PHP."</span>
  <span class="builtin">:type</span> 'string
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defcustom</span> <span class="variable-name">php-manual-path</span> <span class="string">""</span>
  <span class="doc">"Path to the directory which contains the PHP manual."</span>
  <span class="builtin">:type</span> 'string
  <span class="builtin">:group</span> 'php)

<span class="comment-delimiter">;;;</span><span class="comment">###</span><span class="comment"><span class="warning">autoload</span></span><span class="comment">
</span>(<span class="keyword">defcustom</span> <span class="variable-name">php-file-patterns</span> '(<span class="string">"\\.php[s34]?\\'"</span> <span class="string">"\\.phtml\\'"</span> <span class="string">"\\.inc\\'"</span>)
  <span class="doc">"List of file patterns for which to automatically invoke `</span><span class="doc"><span class="constant">php-mode</span></span><span class="doc">'."</span>
  <span class="builtin">:type</span> '(repeat (regexp <span class="builtin">:tag</span> <span class="string">"Pattern"</span>))
  <span class="builtin">:set</span> (<span class="keyword">lambda</span> (sym val)
         (set-default sym val)
         (<span class="keyword">let</span> ((php-file-patterns-temp val))
           (<span class="keyword">while</span> php-file-patterns-temp
             (add-to-list 'auto-mode-alist
                          (cons (car php-file-patterns-temp) 'php-mode))
             (setq php-file-patterns-temp (cdr php-file-patterns-temp)))))
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defcustom</span> <span class="variable-name">php-mode-hook</span> nil
  <span class="doc">"List of functions to be executed on entry to `</span><span class="doc"><span class="constant">php-mode</span></span><span class="doc">'."</span>
  <span class="builtin">:type</span> 'hook
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defcustom</span> <span class="variable-name">php-mode-pear-hook</span> nil
  <span class="doc">"Hook called when a PHP PEAR file is opened with `</span><span class="doc"><span class="constant">php-mode</span></span><span class="doc">'."</span>
  <span class="builtin">:type</span> 'hook
  <span class="builtin">:group</span> 'php)

(<span class="keyword">defcustom</span> <span class="variable-name">php-mode-force-pear</span> nil
  <span class="doc">"Normally PEAR coding rules are enforced only when the filename contains \"PEAR.\"
Turning this on will force PEAR rules on all PHP files."</span>
  <span class="builtin">:type</span> 'boolean
  <span class="builtin">:group</span> 'php)</pre><hr /><pre>
(<span class="keyword">defconst</span> <span class="variable-name">php-mode-modified</span> <span class="string">"2008-11-04"</span>
  <span class="doc">"PHP Mode build date."</span>)

(<span class="keyword">defun</span> <span class="function-name">php-mode-version</span> ()
  <span class="doc">"Display string describing the version of PHP mode."</span>
  (interactive)
  (message <span class="string">"PHP mode %s of %s"</span>
           php-mode-version-number php-mode-modified))</pre><hr /><pre>
(<span class="keyword">defconst</span> <span class="variable-name">php-beginning-of-defun-regexp</span>
  <span class="string">"^\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">abstract</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">final</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">private</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">protected</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">public</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">static</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">*function\\s-+&amp;?</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(?:</span></span><span class="string">\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*("</span>
  <span class="doc">"Regular expression for a PHP function."</span>)

(<span class="keyword">defun</span> <span class="function-name">php-beginning-of-defun</span> (<span class="type">&amp;optional</span> arg)
  <span class="doc">"Move to the beginning of the ARGth PHP function from point.
Implements PHP version of `</span><span class="doc"><span class="constant">beginning-of-defun-function</span></span><span class="doc">'."</span>
  (interactive <span class="string">"p"</span>)
  (<span class="keyword">let</span> ((arg (or arg 1)))
    (<span class="keyword">while</span> (&gt; arg 0)
      (re-search-backward php-beginning-of-defun-regexp
                          nil 'noerror)
      (setq arg (1- arg)))
    (<span class="keyword">while</span> (&lt; arg 0)
      (end-of-line 1)
      (<span class="keyword">let</span> ((opoint (point)))
        (beginning-of-defun 1)
        (forward-list 2)
        (forward-line 1)
        (<span class="keyword">if</span> (eq opoint (point))
            (re-search-forward php-beginning-of-defun-regexp
                               nil 'noerror))
        (setq arg (1+ arg))))))

(<span class="keyword">defun</span> <span class="function-name">php-end-of-defun</span> (<span class="type">&amp;optional</span> arg)
  <span class="doc">"Move the end of the ARGth PHP function from point.
Implements PHP befsion of `</span><span class="doc"><span class="constant">end-of-defun-function</span></span><span class="doc">'

See `</span><span class="doc"><span class="constant">php-beginning-of-defun</span></span><span class="doc">'."</span>
  (interactive <span class="string">"p"</span>)
  (php-beginning-of-defun (- (or arg 1))))
</pre><hr /><pre>
(<span class="keyword">defvar</span> <span class="variable-name">php-warned-bad-indent</span> nil)
(make-variable-buffer-local 'php-warned-bad-indent)

<span class="comment-delimiter">;; </span><span class="comment">Do it but tell it is not good if html tags in buffer.
</span>(<span class="keyword">defun</span> <span class="function-name">php-check-html-for-indentation</span> ()
  (<span class="keyword">let</span> ((html-tag-re <span class="string">"^\\s-*&lt;/?\\sw+.*?&gt;"</span>)
        (here (point)))
    (<span class="keyword">if</span> (not (or (re-search-forward html-tag-re (line-end-position) t)
                 (re-search-backward html-tag-re (line-beginning-position) t)))
        t
      (goto-char here)
      (setq php-warned-bad-indent t)
      (lwarn 'php-indent <span class="builtin">:warning</span>
             <span class="string">"\n\t%s\n\t%s\n\t%s\n"</span>
             <span class="string">"Indentation fails badly with mixed HTML and PHP."</span>
             <span class="string">"Look for an Emacs Lisp library that supports \"multiple"</span>
             <span class="string">"major modes\" like mumamo, mmm-mode or multi-mode."</span>)
      nil)))

(<span class="keyword">defun</span> <span class="function-name">php-cautious-indent-region</span> (start end <span class="type">&amp;optional</span> quiet)
  (<span class="keyword">if</span> (or php-warned-bad-indent
          (php-check-html-for-indentation))
      (funcall 'c-indent-region start end quiet)))

(<span class="keyword">defun</span> <span class="function-name">php-cautious-indent-line</span> ()
  (<span class="keyword">if</span> (or php-warned-bad-indent
          (php-check-html-for-indentation))
      (funcall 'c-indent-line)))</pre><hr /><pre>
(<span class="keyword">defconst</span> <span class="variable-name">php-tags</span> '(<span class="string">"&lt;?php"</span> <span class="string">"?&gt;"</span> <span class="string">"&lt;?"</span> <span class="string">"&lt;?="</span>))
(<span class="keyword">defconst</span> <span class="variable-name">php-tags-key</span> (regexp-opt php-tags))

(<span class="keyword">defconst</span> <span class="variable-name">php-block-stmt-1-kwds</span> '(<span class="string">"do"</span> <span class="string">"else"</span> <span class="string">"finally"</span> <span class="string">"try"</span>))
(<span class="keyword">defconst</span> <span class="variable-name">php-block-stmt-2-kwds</span>
  '(<span class="string">"for"</span> <span class="string">"if"</span> <span class="string">"while"</span> <span class="string">"switch"</span> <span class="string">"foreach"</span> <span class="string">"elseif"</span> <span class="string">"catch all"</span>))

(<span class="keyword">defconst</span> <span class="variable-name">php-block-stmt-1-key</span>
  (regexp-opt php-block-stmt-1-kwds))
(<span class="keyword">defconst</span> <span class="variable-name">php-block-stmt-2-key</span>
  (regexp-opt php-block-stmt-2-kwds))

(<span class="keyword">defconst</span> <span class="variable-name">php-class-decl-kwds</span> '(<span class="string">"class"</span> <span class="string">"interface"</span>))

(<span class="keyword">defconst</span> <span class="variable-name">php-class-key</span>
  (concat
   <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">"</span> (regexp-opt php-class-decl-kwds) <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+"</span>
   (c-lang-const c-symbol-key c)                <span class="comment-delimiter">;; </span><span class="comment">Class name.
</span>   <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\s-+extends\\s-+"</span> (c-lang-const c-symbol-key c) <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?"</span> <span class="comment-delimiter">;; </span><span class="comment">Name of superclass.
</span>   <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\s-+implements\\s-+[</span><span class="string"><span class="negation-char">^</span></span><span class="string">{]+{</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?"</span>)) <span class="comment-delimiter">;; </span><span class="comment">List of any adopted protocols.
</span>
<span class="comment-delimiter">;;;</span><span class="comment">###</span><span class="comment"><span class="warning">autoload</span></span><span class="comment">
</span>(<span class="keyword">define-derived-mode</span> <span class="function-name">php-mode</span> c-mode <span class="string">"PHP"</span>
  <span class="doc">"Major mode for editing PHP code.\n\n\\{php-mode-map}"</span>
  (c-add-language 'php-mode 'c-mode)

<span class="comment-delimiter">;; </span><span class="comment">PHP doesn't have C-style macros.
</span><span class="comment-delimiter">;; </span><span class="comment">HACK: Overwrite this syntax with rules to match &lt;?php and others.
</span><span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defconst c-opt-cpp-start php php-tags-key)
</span><span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defvar c-opt-cpp-start (c-lang-const c-opt-cpp-start))
</span>  (set (make-local-variable 'c-opt-cpp-start) php-tags-key)
<span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defconst c-opt-cpp-start php php-tags-key)
</span><span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defvar c-opt-cpp-start (c-lang-const c-opt-cpp-start))
</span>  (set (make-local-variable 'c-opt-cpp-prefix) php-tags-key)

  (c-set-offset 'cpp-macro 0)
  
<span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defconst c-block-stmt-1-kwds php php-block-stmt-1-kwds)
</span><span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defvar c-block-stmt-1-kwds (c-lang-const c-block-stmt-1-kwds))
</span>  (set (make-local-variable 'c-block-stmt-1-key) php-block-stmt-1-key)

<span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defconst c-block-stmt-2-kwds php php-block-stmt-2-kwds)
</span><span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defvar c-block-stmt-2-kwds (c-lang-const c-block-stmt-2-kwds))
</span>  (set (make-local-variable 'c-block-stmt-2-key) php-block-stmt-2-key)

  <span class="comment-delimiter">;; </span><span class="comment">Specify that cc-mode recognize Javadoc comment style
</span>  (set (make-local-variable 'c-doc-comment-style)
       '((php-mode . javadoc)))

<span class="comment-delimiter">;;   </span><span class="comment">(c-lang-defconst c-class-decl-kwds
</span><span class="comment-delimiter">;;     </span><span class="comment">php php-class-decl-kwds)
</span>  (set (make-local-variable 'c-class-key) php-class-key)

  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
        '((php-font-lock-keywords-1
           php-font-lock-keywords-2
           <span class="comment-delimiter">;; </span><span class="comment">Comment-out the next line if the font-coloring is too
</span>           <span class="comment-delimiter">;; </span><span class="comment">extreme/ugly for you.
</span>           php-font-lock-keywords-3)
          nil                               <span class="comment-delimiter">; </span><span class="comment">KEYWORDS-ONLY
</span>          t                                 <span class="comment-delimiter">; </span><span class="comment">CASE-FOLD
</span>          ((<span class="string">"_"</span> . <span class="string">"w"</span>))                    <span class="comment-delimiter">; </span><span class="comment">SYNTAX-ALIST
</span>          nil))                             <span class="comment-delimiter">; </span><span class="comment">SYNTAX-BEGIN
</span>
  <span class="comment-delimiter">;; </span><span class="comment">Electric behaviour must be turned off, they do not work since
</span>  <span class="comment-delimiter">;; </span><span class="comment">they can not find the correct syntax in embedded PHP.
</span>  <span class="comment-delimiter">;;</span><span class="comment">
</span>  <span class="comment-delimiter">;; </span><span class="comment">Seems to work with narrowing so let it be on if the user prefers it.
</span>  <span class="comment-delimiter">;;</span><span class="comment">(setq c-electric-flag nil)
</span>
  (setq font-lock-maximum-decoration t
        case-fold-search t              <span class="comment-delimiter">; </span><span class="comment">PHP vars are case-sensitive
</span>        imenu-generic-expression php-imenu-generic-expression)

  <span class="comment-delimiter">;; </span><span class="comment">Do not force newline at end of file.  Such newlines can cause
</span>  <span class="comment-delimiter">;; </span><span class="comment">trouble if the PHP file is included in another file before calls
</span>  <span class="comment-delimiter">;; </span><span class="comment">to header() or cookie().
</span>  (set (make-local-variable 'require-final-newline) nil)
  (set (make-local-variable 'next-line-add-newlines) nil)

  <span class="comment-delimiter">;; </span><span class="comment">PEAR coding standards
</span>  (add-hook 'php-mode-pear-hook
            (<span class="keyword">lambda</span> ()
              (set (make-local-variable 'tab-width) 4)
              (set (make-local-variable 'c-basic-offset) 4)
              (set (make-local-variable 'indent-tabs-mode) nil)
              (c-set-offset 'block-open' - )
              (c-set-offset 'block-close' 0 )) nil t)

  (<span class="keyword">if</span> (or php-mode-force-pear
          (and (stringp buffer-file-name)
               (string-match <span class="string">"PEAR</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">pear"</span>
                             (buffer-file-name))
               (string-match <span class="string">"\\.php$"</span> (buffer-file-name))))
      (run-hooks 'php-mode-pear-hook))

  (setq indent-line-function 'php-cautious-indent-line)
  (setq indent-region-function 'php-cautious-indent-region)
  (setq c-special-indent-hook nil)

  (set (make-local-variable 'beginning-of-defun-function)
       'php-beginning-of-defun)
  (set (make-local-variable 'end-of-defun-function)
       'php-end-of-defun)
  (set (make-local-variable 'open-paren-in-column-0-is-defun-start)
       nil)
  (set (make-local-variable 'defun-prompt-regexp)
       <span class="string">"^\\s-*function\\s-+&amp;?\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*"</span>)
  (set (make-local-variable 'add-log-current-defun-header-regexp)
       php-beginning-of-defun-regexp)

  (run-hooks 'php-mode-hook))</pre><hr /><pre>
<span class="comment-delimiter">;; </span><span class="comment">Make a menu keymap (with a prompt string)
</span><span class="comment-delimiter">;; </span><span class="comment">and make it the menu bar item's definition.
</span>(define-key php-mode-map [menu-bar] (make-sparse-keymap))
(define-key php-mode-map [menu-bar php]
  (cons <span class="string">"PHP"</span> (make-sparse-keymap <span class="string">"PHP"</span>)))

<span class="comment-delimiter">;; </span><span class="comment">Define specific subcommands in this menu.
</span>(define-key php-mode-map [menu-bar php complete-function]
  '(<span class="string">"Complete function name"</span> . php-complete-function))
(define-key php-mode-map
  [menu-bar php browse-manual]
  '(<span class="string">"Browse manual"</span> . php-browse-manual))
(define-key php-mode-map
  [menu-bar php search-documentation]
  '(<span class="string">"Search documentation"</span> . php-search-documentation))</pre><hr /><pre>
<span class="comment-delimiter">;; </span><span class="comment">Define function name completion function
</span>(<span class="keyword">defvar</span> <span class="variable-name">php-completion-table</span> nil
  <span class="doc">"Obarray of tag names defined in current tags table and functions known to PHP."</span>)

(<span class="keyword">defun</span> <span class="function-name">php-complete-function</span> ()
  <span class="doc">"Perform function completion on the text around point.
Completes to the set of names listed in the current tags table
and the standard php functions.
The string to complete is chosen in the same way as the default
for \\[</span><span class="doc"><span class="constant">find-tag</span></span><span class="doc">] (which see)."</span>
  (interactive)
  (<span class="keyword">let</span> ((pattern (php-get-pattern))
        beg
        completion
        (php-functions (php-completion-table)))
    (<span class="keyword">if</span> (not pattern) (message <span class="string">"Nothing to complete"</span>)
      (search-backward pattern)
      (setq beg (point))
      (forward-char (length pattern))
      (setq completion (try-completion pattern php-functions nil))
      (<span class="keyword">cond</span> ((eq completion t))
            ((null completion)
             (message <span class="string">"Can't find completion for \"%s\""</span> pattern)
             (ding))
            ((not (string= pattern completion))
             (delete-region beg (point))
             (insert completion))
            (t
             (message <span class="string">"Making completion list..."</span>)
             (<span class="keyword">with-output-to-temp-buffer</span> <span class="string">"*Completions*"</span>
               (display-completion-list
                (all-completions pattern php-functions)))
             (message <span class="string">"Making completion list...%s"</span> <span class="string">"done"</span>))))))

(<span class="keyword">defun</span> <span class="function-name">php-completion-table</span> ()
  <span class="doc">"Build variable `</span><span class="doc"><span class="constant">php-completion-table</span></span><span class="doc">' on demand.
The table includes the PHP functions and the tags from the
current `</span><span class="doc"><span class="constant">tags-file-name</span></span><span class="doc">'."</span>
  (or (and tags-file-name
           (<span class="keyword">save-excursion</span> (tags-verify-table tags-file-name))
           php-completion-table)
      (<span class="keyword">let</span> ((tags-table
             (<span class="keyword">if</span> (and tags-file-name
                      (functionp 'etags-tags-completion-table))
                 (<span class="keyword">with-current-buffer</span> (get-file-buffer tags-file-name)
                   (etags-tags-completion-table))
               nil))
            (php-table
             (<span class="keyword">cond</span> ((and (not (string= <span class="string">""</span> php-completion-file))
                         (file-readable-p php-completion-file))
                    (php-build-table-from-file php-completion-file))
                   (php-manual-path
                    (php-build-table-from-path php-manual-path))
                   (t nil))))
        (<span class="keyword">unless</span> (or php-table tags-table)
          (<span class="warning">error</span>
           (concat <span class="string">"No TAGS file active nor are "</span>
                   <span class="string">"`</span><span class="string"><span class="constant">php-completion-file</span></span><span class="string">' or `</span><span class="string"><span class="constant">php-manual-path</span></span><span class="string">' set"</span>)))
        (<span class="keyword">when</span> tags-table
          <span class="comment-delimiter">;; </span><span class="comment">Combine the tables.
</span>          (mapatoms (<span class="keyword">lambda</span> (sym) (intern (symbol-name sym) php-table))
                    tags-table))
        (setq php-completion-table php-table))))

(<span class="keyword">defun</span> <span class="function-name">php-build-table-from-file</span> (filename)
  (<span class="keyword">let</span> ((table (make-vector 1022 0))
        (buf (find-file-noselect filename)))
    (<span class="keyword">save-excursion</span>
      (set-buffer buf)
      (goto-char (point-min))
      (<span class="keyword">while</span> (re-search-forward
              <span class="string">"^</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">[-a-zA-Z0-9_.]+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\n"</span>
              nil t)
        (intern (buffer-substring (match-beginning 1) (match-end 1))
                table)))
    (kill-buffer buf)
    table))

(<span class="keyword">defun</span> <span class="function-name">php-build-table-from-path</span> (path)
  (<span class="keyword">let</span> ((table (make-vector 1022 0))
        (files (directory-files
                path
                nil
                <span class="string">"^function\\..+\\.html$"</span>)))
    (mapc (<span class="keyword">lambda</span> (file)
            (string-match <span class="string">"\\.</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">[-a-zA-Z_0-9]+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\.html$"</span> file)
            (intern
             (replace-regexp-in-string
              <span class="string">"-"</span> <span class="string">"_"</span> (substring file (match-beginning 1) (match-end 1)) t)
             table))
          files)
    table))

<span class="comment-delimiter">;; </span><span class="comment">Find the pattern we want to complete
</span><span class="comment-delimiter">;; </span><span class="comment">find-tag-default from GNU Emacs etags.el
</span>(<span class="keyword">defun</span> <span class="function-name">php-get-pattern</span> ()
  (<span class="keyword">save-excursion</span>
    (<span class="keyword">while</span> (looking-at <span class="string">"\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_"</span>)
      (forward-char 1))
    (<span class="keyword">if</span> (or (re-search-backward <span class="string">"\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_"</span>
                                (<span class="keyword">save-excursion</span> (beginning-of-line) (point))
                                t)
            (re-search-forward <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">\\s_</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">+"</span>
                               (<span class="keyword">save-excursion</span> (end-of-line) (point))
                               t))
        (<span class="keyword">progn</span> (goto-char (match-end 0))
               (buffer-substring-no-properties
                (point)
                (<span class="keyword">progn</span> (forward-sexp -1)
                       (<span class="keyword">while</span> (looking-at <span class="string">"\\s'"</span>)
                         (forward-char 1))
                       (point))))
      nil)))

(<span class="keyword">defun</span> <span class="function-name">php-show-arglist</span> ()
  (interactive)
  (<span class="keyword">let*</span> ((tagname (php-get-pattern))
         (buf (find-tag-noselect tagname nil nil))
         arglist)
    (<span class="keyword">save-excursion</span>
      (set-buffer buf)
      (goto-char (point-min))
      (<span class="keyword">when</span> (re-search-forward
             (format <span class="string">"function\\s-+%s\\s-*(</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">[</span><span class="string"><span class="negation-char">^</span></span><span class="string">{]*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">)"</span> tagname)
             nil t)
        (setq arglist (buffer-substring-no-properties
                       (match-beginning 1) (match-end 1)))))
    (<span class="keyword">if</span> arglist
        (message <span class="string">"Arglist for %s: %s"</span> tagname arglist)
        (message <span class="string">"Unknown function: %s"</span> tagname))))</pre><hr /><pre>
<span class="comment-delimiter">;; </span><span class="comment">Define function documentation function
</span>(<span class="keyword">defun</span> <span class="function-name">php-search-documentation</span> ()
  <span class="doc">"Search PHP documentation for the word at point."</span>
  (interactive)
  (browse-url (concat php-search-url (current-word t))))

<span class="comment-delimiter">;; </span><span class="comment">Define function for browsing manual
</span>(<span class="keyword">defun</span> <span class="function-name">php-browse-manual</span> ()
  <span class="doc">"Bring up manual for PHP."</span>
  (interactive)
  (browse-url php-manual-url))

<span class="comment-delimiter">;; </span><span class="comment">Define shortcut
</span>(define-key php-mode-map
  <span class="string">"\C-c\C-f"</span>
  'php-search-documentation)

<span class="comment-delimiter">;; </span><span class="comment">Define shortcut
</span>(define-key php-mode-map
  [(meta tab)]
  'php-complete-function)

<span class="comment-delimiter">;; </span><span class="comment">Define shortcut
</span>(define-key php-mode-map
  <span class="string">"\C-c\C-m"</span>
  'php-browse-manual)

<span class="comment-delimiter">;; </span><span class="comment">Define shortcut
</span>(define-key php-mode-map
  '[(control .)]
  'php-show-arglist)</pre><hr /><pre>
(<span class="keyword">defconst</span> <span class="variable-name">php-constants</span>
  (<span class="keyword">eval-when-compile</span>
    (regexp-opt
     '(<span class="comment-delimiter">;; </span><span class="comment">core constants
</span>       <span class="string">"__LINE__"</span> <span class="string">"__FILE__"</span>
       <span class="string">"__FUNCTION__"</span> <span class="string">"__CLASS__"</span> <span class="string">"__METHOD__"</span>
       <span class="string">"PHP_OS"</span> <span class="string">"PHP_VERSION"</span>
       <span class="string">"TRUE"</span> <span class="string">"FALSE"</span> <span class="string">"NULL"</span>
       <span class="string">"E_ERROR"</span> <span class="string">"E_NOTICE"</span> <span class="string">"E_PARSE"</span> <span class="string">"E_WARNING"</span> <span class="string">"E_ALL"</span> <span class="string">"E_STRICT"</span>
       <span class="string">"E_USER_ERROR"</span> <span class="string">"E_USER_WARNING"</span> <span class="string">"E_USER_NOTICE"</span>
       <span class="string">"DEFAULT_INCLUDE_PATH"</span> <span class="string">"PEAR_INSTALL_DIR"</span> <span class="string">"PEAR_EXTENSION_DIR"</span>
       <span class="string">"PHP_BINDIR"</span> <span class="string">"PHP_LIBDIR"</span> <span class="string">"PHP_DATADIR"</span> <span class="string">"PHP_SYSCONFDIR"</span>
       <span class="string">"PHP_LOCALSTATEDIR"</span> <span class="string">"PHP_CONFIG_FILE_PATH"</span>
       <span class="string">"PHP_EOL"</span>

       <span class="comment-delimiter">;; </span><span class="comment">date and time constants
</span>       <span class="string">"DATE_ATOM"</span> <span class="string">"DATE_COOKIE"</span> <span class="string">"DATE_ISO8601"</span>
       <span class="string">"DATE_RFC822"</span> <span class="string">"DATE_RFC850"</span> <span class="string">"DATE_RFC1036"</span> <span class="string">"DATE_RFC1123"</span>
       <span class="string">"DATE_RFC2822"</span> <span class="string">"DATE_RFC3339"</span>
       <span class="string">"DATE_RSS"</span> <span class="string">"DATE_W3C"</span>

       <span class="comment-delimiter">;; </span><span class="comment">from ext/standard:
</span>       <span class="string">"EXTR_OVERWRITE"</span> <span class="string">"EXTR_SKIP"</span> <span class="string">"EXTR_PREFIX_SAME"</span>
       <span class="string">"EXTR_PREFIX_ALL"</span> <span class="string">"EXTR_PREFIX_INVALID"</span> <span class="string">"SORT_ASC"</span> <span class="string">"SORT_DESC"</span>
       <span class="string">"SORT_REGULAR"</span> <span class="string">"SORT_NUMERIC"</span> <span class="string">"SORT_STRING"</span> <span class="string">"ASSERT_ACTIVE"</span>
       <span class="string">"ASSERT_CALLBACK"</span> <span class="string">"ASSERT_BAIL"</span> <span class="string">"ASSERT_WARNING"</span>
       <span class="string">"ASSERT_QUIET_EVAL"</span> <span class="string">"CONNECTION_ABORTED"</span> <span class="string">"CONNECTION_NORMAL"</span>
       <span class="string">"CONNECTION_TIMEOUT"</span> <span class="string">"M_E"</span> <span class="string">"M_LOG2E"</span> <span class="string">"M_LOG10E"</span> <span class="string">"M_LN2"</span>
       <span class="string">"M_LN10"</span> <span class="string">"M_PI"</span> <span class="string">"M_PI_2"</span> <span class="string">"M_PI_4"</span> <span class="string">"M_1_PI"</span> <span class="string">"M_2_PI"</span>
       <span class="string">"M_2_SQRTPI"</span> <span class="string">"M_SQRT2"</span> <span class="string">"M_SQRT1_2"</span> <span class="string">"CRYPT_SALT_LENGTH"</span>
       <span class="string">"CRYPT_STD_DES"</span> <span class="string">"CRYPT_EXT_DES"</span> <span class="string">"CRYPT_MD5"</span> <span class="string">"CRYPT_BLOWFISH"</span>
       <span class="string">"DIRECTORY_SEPARATOR"</span> <span class="string">"SEEK_SET"</span> <span class="string">"SEEK_CUR"</span> <span class="string">"SEEK_END"</span>
       <span class="string">"LOCK_SH"</span> <span class="string">"LOCK_EX"</span> <span class="string">"LOCK_UN"</span> <span class="string">"LOCK_NB"</span> <span class="string">"HTML_SPECIALCHARS"</span>
       <span class="string">"HTML_ENTITIES"</span> <span class="string">"ENT_COMPAT"</span> <span class="string">"ENT_QUOTES"</span> <span class="string">"ENT_NOQUOTES"</span>
       <span class="string">"INFO_GENERAL"</span> <span class="string">"INFO_CREDITS"</span> <span class="string">"INFO_CONFIGURATION"</span>
       <span class="string">"INFO_ENVIRONMENT"</span> <span class="string">"INFO_VARIABLES"</span> <span class="string">"INFO_LICENSE"</span> <span class="string">"INFO_ALL"</span>
       <span class="string">"CREDITS_GROUP"</span> <span class="string">"CREDITS_GENERAL"</span> <span class="string">"CREDITS_SAPI"</span>
       <span class="string">"CREDITS_MODULES"</span> <span class="string">"CREDITS_DOCS"</span> <span class="string">"CREDITS_FULLPAGE"</span>
       <span class="string">"CREDITS_QA"</span> <span class="string">"CREDITS_ALL"</span> <span class="string">"PHP_OUTPUT_HANDLER_START"</span>
       <span class="string">"PHP_OUTPUT_HANDLER_CONT"</span> <span class="string">"PHP_OUTPUT_HANDLER_END"</span>
       <span class="string">"STR_PAD_LEFT"</span> <span class="string">"STR_PAD_RIGHT"</span> <span class="string">"STR_PAD_BOTH"</span>
       <span class="string">"PATHINFO_DIRNAME"</span> <span class="string">"PATHINFO_BASENAME"</span> <span class="string">"PATHINFO_EXTENSION"</span>
       <span class="string">"CHAR_MAX"</span> <span class="string">"LC_CTYPE"</span> <span class="string">"LC_NUMERIC"</span> <span class="string">"LC_TIME"</span> <span class="string">"LC_COLLATE"</span>
       <span class="string">"LC_MONETARY"</span> <span class="string">"LC_ALL"</span> <span class="string">"LC_MESSAGES"</span> <span class="string">"LOG_EMERG"</span> <span class="string">"LOG_ALERT"</span>
       <span class="string">"LOG_CRIT"</span> <span class="string">"LOG_ERR"</span> <span class="string">"LOG_WARNING"</span> <span class="string">"LOG_NOTICE"</span> <span class="string">"LOG_INFO"</span>
       <span class="string">"LOG_DEBUG"</span> <span class="string">"LOG_KERN"</span> <span class="string">"LOG_USER"</span> <span class="string">"LOG_MAIL"</span> <span class="string">"LOG_DAEMON"</span>
       <span class="string">"LOG_AUTH"</span> <span class="string">"LOG_SYSLOG"</span> <span class="string">"LOG_LPR"</span> <span class="string">"LOG_NEWS"</span> <span class="string">"LOG_UUCP"</span>
       <span class="string">"LOG_CRON"</span> <span class="string">"LOG_AUTHPRIV"</span> <span class="string">"LOG_LOCAL0"</span> <span class="string">"LOG_LOCAL1"</span>
       <span class="string">"LOG_LOCAL2"</span> <span class="string">"LOG_LOCAL3"</span> <span class="string">"LOG_LOCAL4"</span> <span class="string">"LOG_LOCAL5"</span>
       <span class="string">"LOG_LOCAL6"</span> <span class="string">"LOG_LOCAL7"</span> <span class="string">"LOG_PID"</span> <span class="string">"LOG_CONS"</span> <span class="string">"LOG_ODELAY"</span>
       <span class="string">"LOG_NDELAY"</span> <span class="string">"LOG_NOWAIT"</span> <span class="string">"LOG_PERROR"</span>

       <span class="comment-delimiter">;; </span><span class="comment">Disabled by default because they slow buffer loading
</span>       <span class="comment-delimiter">;; </span><span class="comment">If you have use for them, uncomment the strings
</span>       <span class="comment-delimiter">;; </span><span class="comment">that you want colored.
</span>       <span class="comment-delimiter">;; </span><span class="comment">To compile, you may have to increase 'max-specpdl-size'
</span>
       <span class="comment-delimiter">;; </span><span class="comment">from other bundled extensions:
</span><span class="comment-delimiter">;        </span><span class="comment">"CAL_EASTER_TO_xxx" "VT_NULL" "VT_EMPTY" "VT_UI1" "VT_I2"
</span><span class="comment-delimiter">;        </span><span class="comment">"VT_I4" "VT_R4" "VT_R8" "VT_BOOL" "VT_ERROR" "VT_CY" "VT_DATE"
</span><span class="comment-delimiter">;        </span><span class="comment">"VT_BSTR" "VT_DECIMAL" "VT_UNKNOWN" "VT_DISPATCH" "VT_VARIANT"
</span><span class="comment-delimiter">;        </span><span class="comment">"VT_I1" "VT_UI2" "VT_UI4" "VT_INT" "VT_UINT" "VT_ARRAY"
</span><span class="comment-delimiter">;        </span><span class="comment">"VT_BYREF" "CP_ACP" "CP_MACCP" "CP_OEMCP" "CP_SYMBOL"
</span><span class="comment-delimiter">;        </span><span class="comment">"CP_THREAD_ACP" "CP_UTF7" "CP_UTF8" "CPDF_PM_NONE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CPDF_PM_OUTLINES" "CPDF_PM_THUMBS" "CPDF_PM_FULLSCREEN"
</span><span class="comment-delimiter">;        </span><span class="comment">"CPDF_PL_SINGLE" "CPDF_PL_1COLUMN" "CPDF_PL_2LCOLUMN"
</span><span class="comment-delimiter">;        </span><span class="comment">"CPDF_PL_2RCOLUMN" "CURLOPT_PORT" "CURLOPT_FILE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_INFILE" "CURLOPT_INFILESIZE" "CURLOPT_URL"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_PROXY" "CURLOPT_VERBOSE" "CURLOPT_HEADER"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_HTTPHEADER" "CURLOPT_NOPROGRESS" "CURLOPT_NOBODY"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_FAILONERROR" "CURLOPT_UPLOAD" "CURLOPT_POST"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_FTPLISTONLY" "CURLOPT_FTPAPPEND" "CURLOPT_NETRC"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_FOLLOWLOCATION" "CURLOPT_FTPASCII" "CURLOPT_PUT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_MUTE" "CURLOPT_USERPWD" "CURLOPT_PROXYUSERPWD"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_RANGE" "CURLOPT_TIMEOUT" "CURLOPT_POSTFIELDS"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_REFERER" "CURLOPT_USERAGENT" "CURLOPT_FTPPORT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_LOW_SPEED_LIMIT" "CURLOPT_LOW_SPEED_TIME"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_RESUME_FROM" "CURLOPT_COOKIE" "CURLOPT_SSLCERT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_SSLCERTPASSWD" "CURLOPT_WRITEHEADER"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_COOKIEFILE" "CURLOPT_SSLVERSION"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_TIMECONDITION" "CURLOPT_TIMEVALUE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_CUSTOMREQUEST" "CURLOPT_STDERR" "CURLOPT_TRANSFERTEXT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_RETURNTRANSFER" "CURLOPT_QUOTE" "CURLOPT_POSTQUOTE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_INTERFACE" "CURLOPT_KRB4LEVEL"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_HTTPPROXYTUNNEL" "CURLOPT_FILETIME"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_WRITEFUNCTION" "CURLOPT_READFUNCTION"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_PASSWDFUNCTION" "CURLOPT_HEADERFUNCTION"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_MAXREDIRS" "CURLOPT_MAXCONNECTS" "CURLOPT_CLOSEPOLICY"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_FRESH_CONNECT" "CURLOPT_FORBID_REUSE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_RANDOM_FILE" "CURLOPT_EGDSOCKET"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_CONNECTTIMEOUT" "CURLOPT_SSL_VERIFYPEER"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLOPT_CAINFO" "CURLOPT_BINARYTRANSER"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLCLOSEPOLICY_LEAST_RECENTLY_USED" "CURLCLOSEPOLICY_OLDEST"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLINFO_EFFECTIVE_URL" "CURLINFO_HTTP_CODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLINFO_HEADER_SIZE" "CURLINFO_REQUEST_SIZE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLINFO_TOTAL_TIME" "CURLINFO_NAMELOOKUP_TIME"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLINFO_CONNECT_TIME" "CURLINFO_PRETRANSFER_TIME"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLINFO_SIZE_UPLOAD" "CURLINFO_SIZE_DOWNLOAD"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLINFO_SPEED_DOWNLOAD" "CURLINFO_SPEED_UPLOAD"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLINFO_FILETIME" "CURLE_OK" "CURLE_UNSUPPORTED_PROTOCOL"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FAILED_INIT" "CURLE_URL_MALFORMAT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_URL_MALFORMAT_USER" "CURLE_COULDNT_RESOLVE_PROXY"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_COULDNT_RESOLVE_HOST" "CURLE_COULDNT_CONNECT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_WEIRD_SERVER_REPLY" "CURLE_FTP_ACCESS_DENIED"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_USER_PASSWORD_INCORRECT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_WEIRD_PASS_REPLY" "CURLE_FTP_WEIRD_USER_REPLY"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_WEIRD_PASV_REPLY" "CURLE_FTP_WEIRD_227_FORMAT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_CANT_GET_HOST" "CURLE_FTP_CANT_RECONNECT"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_COULDNT_SET_BINARY" "CURLE_PARTIAL_FILE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_COULDNT_RETR_FILE" "CURLE_FTP_WRITE_ERROR"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_QUOTE_ERROR" "CURLE_HTTP_NOT_FOUND"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_WRITE_ERROR" "CURLE_MALFORMAT_USER"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_COULDNT_STOR_FILE" "CURLE_READ_ERROR"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_OUT_OF_MEMORY" "CURLE_OPERATION_TIMEOUTED"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_COULDNT_SET_ASCII" "CURLE_FTP_PORT_FAILED"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FTP_COULDNT_USE_REST" "CURLE_FTP_COULDNT_GET_SIZE"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_HTTP_RANGE_ERROR" "CURLE_HTTP_POST_ERROR"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_SSL_CONNECT_ERROR" "CURLE_FTP_BAD_DOWNLOAD_RESUME"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FILE_COULDNT_READ_FILE" "CURLE_LDAP_CANNOT_BIND"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_LDAP_SEARCH_FAILED" "CURLE_LIBRARY_NOT_FOUND"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_FUNCTION_NOT_FOUND" "CURLE_ABORTED_BY_CALLBACK"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_BAD_FUNCTION_ARGUMENT" "CURLE_BAD_CALLING_ORDER"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_HTTP_PORT_FAILED" "CURLE_BAD_PASSWORD_ENTERED"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_TOO_MANY_REDIRECTS" "CURLE_UNKOWN_TELNET_OPTION"
</span><span class="comment-delimiter">;        </span><span class="comment">"CURLE_TELNET_OPTION_SYNTAX" "CURLE_ALREADY_COMPLETE"
</span><span class="comment-delimiter">;        </span><span class="comment">"DBX_MYSQL" "DBX_ODBC" "DBX_PGSQL" "DBX_MSSQL" "DBX_PERSISTENT"
</span><span class="comment-delimiter">;        </span><span class="comment">"DBX_RESULT_INFO" "DBX_RESULT_INDEX" "DBX_RESULT_ASSOC"
</span><span class="comment-delimiter">;        </span><span class="comment">"DBX_CMP_TEXT" "DBX_CMP_NUMBER" "XML_ELEMENT_NODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ATTRIBUTE_NODE" "XML_TEXT_NODE" "XML_CDATA_SECTION_NODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ENTITY_REF_NODE" "XML_ENTITY_NODE" "XML_PI_NODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_COMMENT_NODE" "XML_DOCUMENT_NODE" "XML_DOCUMENT_TYPE_NODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_DOCUMENT_FRAG_NODE" "XML_NOTATION_NODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_HTML_DOCUMENT_NODE" "XML_DTD_NODE" "XML_ELEMENT_DECL_NODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ATTRIBUTE_DECL_NODE" "XML_ENTITY_DECL_NODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_NAMESPACE_DECL_NODE" "XML_GLOBAL_NAMESPACE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_LOCAL_NAMESPACE" "XML_ATTRIBUTE_CDATA" "XML_ATTRIBUTE_ID"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ATTRIBUTE_IDREF" "XML_ATTRIBUTE_IDREFS"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ATTRIBUTE_ENTITY" "XML_ATTRIBUTE_NMTOKEN"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ATTRIBUTE_NMTOKENS" "XML_ATTRIBUTE_ENUMERATION"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ATTRIBUTE_NOTATION" "XPATH_UNDEFINED" "XPATH_NODESET"
</span><span class="comment-delimiter">;        </span><span class="comment">"XPATH_BOOLEAN" "XPATH_NUMBER" "XPATH_STRING" "XPATH_POINT"
</span><span class="comment-delimiter">;        </span><span class="comment">"XPATH_RANGE" "XPATH_LOCATIONSET" "XPATH_USERS" "FBSQL_ASSOC"
</span><span class="comment-delimiter">;        </span><span class="comment">"FBSQL_NUM" "FBSQL_BOTH" "FDFValue" "FDFStatus" "FDFFile"
</span><span class="comment-delimiter">;        </span><span class="comment">"FDFID" "FDFFf" "FDFSetFf" "FDFClearFf" "FDFFlags" "FDFSetF"
</span><span class="comment-delimiter">;        </span><span class="comment">"FDFClrF" "FDFAP" "FDFAS" "FDFAction" "FDFAA" "FDFAPRef"
</span><span class="comment-delimiter">;        </span><span class="comment">"FDFIF" "FDFEnter" "FDFExit" "FDFDown" "FDFUp" "FDFFormat"
</span><span class="comment-delimiter">;        </span><span class="comment">"FDFValidate" "FDFKeystroke" "FDFCalculate"
</span><span class="comment-delimiter">;        </span><span class="comment">"FRIBIDI_CHARSET_UTF8" "FRIBIDI_CHARSET_8859_6"
</span><span class="comment-delimiter">;        </span><span class="comment">"FRIBIDI_CHARSET_8859_8" "FRIBIDI_CHARSET_CP1255"
</span><span class="comment-delimiter">;        </span><span class="comment">"FRIBIDI_CHARSET_CP1256" "FRIBIDI_CHARSET_ISIRI_3342"
</span><span class="comment-delimiter">;        </span><span class="comment">"FTP_ASCII" "FTP_BINARY" "FTP_IMAGE" "FTP_TEXT" "IMG_GIF"
</span><span class="comment-delimiter">;        </span><span class="comment">"IMG_JPG" "IMG_JPEG" "IMG_PNG" "IMG_WBMP" "IMG_COLOR_TILED"
</span><span class="comment-delimiter">;        </span><span class="comment">"IMG_COLOR_STYLED" "IMG_COLOR_BRUSHED"
</span><span class="comment-delimiter">;        </span><span class="comment">"IMG_COLOR_STYLEDBRUSHED" "IMG_COLOR_TRANSPARENT"
</span><span class="comment-delimiter">;        </span><span class="comment">"IMG_ARC_ROUNDED" "IMG_ARC_PIE" "IMG_ARC_CHORD"
</span><span class="comment-delimiter">;        </span><span class="comment">"IMG_ARC_NOFILL" "IMG_ARC_EDGED" "GMP_ROUND_ZERO"
</span><span class="comment-delimiter">;        </span><span class="comment">"GMP_ROUND_PLUSINF" "GMP_ROUND_MINUSINF" "HW_ATTR_LANG"
</span><span class="comment-delimiter">;        </span><span class="comment">"HW_ATTR_NR" "HW_ATTR_NONE" "IIS_READ" "IIS_WRITE"
</span><span class="comment-delimiter">;        </span><span class="comment">"IIS_EXECUTE" "IIS_SCRIPT" "IIS_ANONYMOUS" "IIS_BASIC"
</span><span class="comment-delimiter">;        </span><span class="comment">"IIS_NTLM" "NIL" "OP_DEBUG" "OP_READONLY" "OP_ANONYMOUS"
</span><span class="comment-delimiter">;        </span><span class="comment">"OP_SHORTCACHE" "OP_SILENT" "OP_PROTOTYPE" "OP_HALFOPEN"
</span><span class="comment-delimiter">;        </span><span class="comment">"OP_EXPUNGE" "OP_SECURE" "CL_EXPUNGE" "FT_UID" "FT_PEEK"
</span><span class="comment-delimiter">;        </span><span class="comment">"FT_NOT" "FT_INTERNAL" "FT_PREFETCHTEXT" "ST_UID" "ST_SILENT"
</span><span class="comment-delimiter">;        </span><span class="comment">"ST_SET" "CP_UID" "CP_MOVE" "SE_UID" "SE_FREE" "SE_NOPREFETCH"
</span><span class="comment-delimiter">;        </span><span class="comment">"SO_FREE" "SO_NOSERVER" "SA_MESSAGES" "SA_RECENT" "SA_UNSEEN"
</span><span class="comment-delimiter">;        </span><span class="comment">"SA_UIDNEXT" "SA_UIDVALIDITY" "SA_ALL" "LATT_NOINFERIORS"
</span><span class="comment-delimiter">;        </span><span class="comment">"LATT_NOSELECT" "LATT_MARKED" "LATT_UNMARKED" "SORTDATE"
</span><span class="comment-delimiter">;        </span><span class="comment">"SORTARRIVAL" "SORTFROM" "SORTSUBJECT" "SORTTO" "SORTCC"
</span><span class="comment-delimiter">;        </span><span class="comment">"SORTSIZE" "TYPETEXT" "TYPEMULTIPART" "TYPEMESSAGE"
</span><span class="comment-delimiter">;        </span><span class="comment">"TYPEAPPLICATION" "TYPEAUDIO" "TYPEIMAGE" "TYPEVIDEO"
</span><span class="comment-delimiter">;        </span><span class="comment">"TYPEOTHER" "ENC7BIT" "ENC8BIT" "ENCBINARY" "ENCBASE64"
</span><span class="comment-delimiter">;        </span><span class="comment">"ENCQUOTEDPRINTABLE" "ENCOTHER" "INGRES_ASSOC" "INGRES_NUM"
</span><span class="comment-delimiter">;        </span><span class="comment">"INGRES_BOTH" "IBASE_DEFAULT" "IBASE_TEXT" "IBASE_UNIXTIME"
</span><span class="comment-delimiter">;        </span><span class="comment">"IBASE_READ" "IBASE_COMMITTED" "IBASE_CONSISTENCY"
</span><span class="comment-delimiter">;        </span><span class="comment">"IBASE_NOWAIT" "IBASE_TIMESTAMP" "IBASE_DATE" "IBASE_TIME"
</span><span class="comment-delimiter">;        </span><span class="comment">"LDAP_DEREF_NEVER" "LDAP_DEREF_SEARCHING" "LDAP_DEREF_FINDING"
</span><span class="comment-delimiter">;        </span><span class="comment">"LDAP_DEREF_ALWAYS" "LDAP_OPT_DEREF" "LDAP_OPT_SIZELIMIT"
</span><span class="comment-delimiter">;        </span><span class="comment">"LDAP_OPT_TIMELIMIT" "LDAP_OPT_PROTOCOL_VERSION"
</span><span class="comment-delimiter">;        </span><span class="comment">"LDAP_OPT_ERROR_NUMBER" "LDAP_OPT_REFERRALS" "LDAP_OPT_RESTART"
</span><span class="comment-delimiter">;        </span><span class="comment">"LDAP_OPT_HOST_NAME" "LDAP_OPT_ERROR_STRING"
</span><span class="comment-delimiter">;        </span><span class="comment">"LDAP_OPT_MATCHED_DN" "LDAP_OPT_SERVER_CONTROLS"
</span><span class="comment-delimiter">;        </span><span class="comment">"LDAP_OPT_CLIENT_CONTROLS" "GSLC_SSL_NO_AUTH"
</span><span class="comment-delimiter">;        </span><span class="comment">"GSLC_SSL_ONEWAY_AUTH" "GSLC_SSL_TWOWAY_AUTH" "MCAL_SUNDAY"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_MONDAY" "MCAL_TUESDAY" "MCAL_WEDNESDAY" "MCAL_THURSDAY"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_FRIDAY" "MCAL_SATURDAY" "MCAL_JANUARY" "MCAL_FEBRUARY"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_MARCH" "MCAL_APRIL" "MCAL_MAY" "MCAL_JUNE" "MCAL_JULY"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_AUGUST" "MCAL_SEPTEMBER" "MCAL_OCTOBER" "MCAL_NOVEMBER"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_RECUR_NONE" "MCAL_RECUR_DAILY" "MCAL_RECUR_WEEKLY"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_RECUR_MONTHLY_MDAY" "MCAL_RECUR_MONTHLY_WDAY"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_RECUR_YEARLY" "MCAL_M_SUNDAY" "MCAL_M_MONDAY"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_M_TUESDAY" "MCAL_M_WEDNESDAY" "MCAL_M_THURSDAY"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_M_FRIDAY" "MCAL_M_SATURDAY" "MCAL_M_WEEKDAYS"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCAL_M_WEEKEND" "MCAL_M_ALLDAYS" "MCRYPT_" "MCRYPT_"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCRYPT_ENCRYPT" "MCRYPT_DECRYPT" "MCRYPT_DEV_RANDOM"
</span><span class="comment-delimiter">;        </span><span class="comment">"MCRYPT_DEV_URANDOM" "MCRYPT_RAND" "SWFBUTTON_HIT"
</span><span class="comment-delimiter">;        </span><span class="comment">"SUNFUNCS_RET_STRING" "SUNFUNCS_RET_DOUBLE"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFBUTTON_DOWN" "SWFBUTTON_OVER" "SWFBUTTON_UP"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFBUTTON_MOUSEUPOUTSIDE" "SWFBUTTON_DRAGOVER"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFBUTTON_DRAGOUT" "SWFBUTTON_MOUSEUP" "SWFBUTTON_MOUSEDOWN"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFBUTTON_MOUSEOUT" "SWFBUTTON_MOUSEOVER"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFFILL_RADIAL_GRADIENT" "SWFFILL_LINEAR_GRADIENT"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFFILL_TILED_BITMAP" "SWFFILL_CLIPPED_BITMAP"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFTEXTFIELD_HASLENGTH" "SWFTEXTFIELD_NOEDIT"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFTEXTFIELD_PASSWORD" "SWFTEXTFIELD_MULTILINE"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFTEXTFIELD_WORDWRAP" "SWFTEXTFIELD_DRAWBOX"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFTEXTFIELD_NOSELECT" "SWFTEXTFIELD_HTML"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFTEXTFIELD_ALIGN_LEFT" "SWFTEXTFIELD_ALIGN_RIGHT"
</span><span class="comment-delimiter">;        </span><span class="comment">"SWFTEXTFIELD_ALIGN_CENTER" "SWFTEXTFIELD_ALIGN_JUSTIFY"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_FIELD_URLID" "UDM_FIELD_URL" "UDM_FIELD_CONTENT"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_FIELD_TITLE" "UDM_FIELD_KEYWORDS" "UDM_FIELD_DESC"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_FIELD_DESCRIPTION" "UDM_FIELD_TEXT" "UDM_FIELD_SIZE"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_FIELD_RATING" "UDM_FIELD_SCORE" "UDM_FIELD_MODIFIED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_FIELD_ORDER" "UDM_FIELD_CRC" "UDM_FIELD_CATEGORY"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_PAGE_SIZE" "UDM_PARAM_PAGE_NUM"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_SEARCH_MODE" "UDM_PARAM_CACHE_MODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_TRACK_MODE" "UDM_PARAM_PHRASE_MODE"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_CHARSET" "UDM_PARAM_STOPTABLE"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_STOP_TABLE" "UDM_PARAM_STOPFILE"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_STOP_FILE" "UDM_PARAM_WEIGHT_FACTOR"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_WORD_MATCH" "UDM_PARAM_MAX_WORD_LEN"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_MAX_WORDLEN" "UDM_PARAM_MIN_WORD_LEN"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_MIN_WORDLEN" "UDM_PARAM_ISPELL_PREFIXES"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_ISPELL_PREFIX" "UDM_PARAM_PREFIXES"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_PREFIX" "UDM_PARAM_CROSS_WORDS"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_CROSSWORDS" "UDM_LIMIT_CAT" "UDM_LIMIT_URL"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_LIMIT_TAG" "UDM_LIMIT_LANG" "UDM_LIMIT_DATE"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_FOUND" "UDM_PARAM_NUM_ROWS" "UDM_PARAM_WORDINFO"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_WORD_INFO" "UDM_PARAM_SEARCHTIME"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_SEARCH_TIME" "UDM_PARAM_FIRST_DOC"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PARAM_LAST_DOC" "UDM_MODE_ALL" "UDM_MODE_ANY"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_MODE_BOOL" "UDM_MODE_PHRASE" "UDM_CACHE_ENABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_CACHE_DISABLED" "UDM_TRACK_ENABLED" "UDM_TRACK_DISABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PHRASE_ENABLED" "UDM_PHRASE_DISABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_CROSS_WORDS_ENABLED" "UDM_CROSSWORDS_ENABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_CROSS_WORDS_DISABLED" "UDM_CROSSWORDS_DISABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PREFIXES_ENABLED" "UDM_PREFIX_ENABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_ISPELL_PREFIXES_ENABLED" "UDM_ISPELL_PREFIX_ENABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_PREFIXES_DISABLED" "UDM_PREFIX_DISABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_ISPELL_PREFIXES_DISABLED" "UDM_ISPELL_PREFIX_DISABLED"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_ISPELL_TYPE_AFFIX" "UDM_ISPELL_TYPE_SPELL"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_ISPELL_TYPE_DB" "UDM_ISPELL_TYPE_SERVER" "UDM_MATCH_WORD"
</span><span class="comment-delimiter">;        </span><span class="comment">"UDM_MATCH_BEGIN" "UDM_MATCH_SUBSTR" "UDM_MATCH_END"
</span><span class="comment-delimiter">;        </span><span class="comment">"MSQL_ASSOC" "MSQL_NUM" "MSQL_BOTH" "MYSQL_ASSOC" "MYSQL_NUM"
</span><span class="comment-delimiter">;        </span><span class="comment">"MYSQL_BOTH" "MYSQL_USE_RESULT" "MYSQL_STORE_RESULT"
</span><span class="comment-delimiter">;        </span><span class="comment">"OCI_DEFAULT" "OCI_DESCRIBE_ONLY" "OCI_COMMIT_ON_SUCCESS"
</span><span class="comment-delimiter">;        </span><span class="comment">"OCI_EXACT_FETCH" "SQLT_BFILEE" "SQLT_CFILEE" "SQLT_CLOB"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQLT_BLOB" "SQLT_RDD" "OCI_B_SQLT_NTY" "OCI_SYSDATE"
</span><span class="comment-delimiter">;        </span><span class="comment">"OCI_B_BFILE" "OCI_B_CFILEE" "OCI_B_CLOB" "OCI_B_BLOB"
</span><span class="comment-delimiter">;        </span><span class="comment">"OCI_B_ROWID" "OCI_B_CURSOR" "OCI_B_BIN" "OCI_ASSOC" "OCI_NUM"
</span><span class="comment-delimiter">;        </span><span class="comment">"OCI_BOTH" "OCI_RETURN_NULLS" "OCI_RETURN_LOBS"
</span><span class="comment-delimiter">;        </span><span class="comment">"OCI_DTYPE_FILE" "OCI_DTYPE_LOB" "OCI_DTYPE_ROWID" "OCI_D_FILE"
</span><span class="comment-delimiter">;        </span><span class="comment">"OCI_D_LOB" "OCI_D_ROWID" "ODBC_TYPE" "ODBC_BINMODE_PASSTHRU"
</span><span class="comment-delimiter">;        </span><span class="comment">"ODBC_BINMODE_RETURN" "ODBC_BINMODE_CONVERT" "SQL_ODBC_CURSORS"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_CUR_USE_DRIVER" "SQL_CUR_USE_IF_NEEDED" "SQL_CUR_USE_ODBC"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_CONCURRENCY" "SQL_CONCUR_READ_ONLY" "SQL_CONCUR_LOCK"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_CONCUR_ROWVER" "SQL_CONCUR_VALUES" "SQL_CURSOR_TYPE"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_CURSOR_FORWARD_ONLY" "SQL_CURSOR_KEYSET_DRIVEN"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_CURSOR_DYNAMIC" "SQL_CURSOR_STATIC" "SQL_KEYSET_SIZE"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_CHAR" "SQL_VARCHAR" "SQL_LONGVARCHAR" "SQL_DECIMAL"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_NUMERIC" "SQL_BIT" "SQL_TINYINT" "SQL_SMALLINT"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_INTEGER" "SQL_BIGINT" "SQL_REAL" "SQL_FLOAT" "SQL_DOUBLE"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_BINARY" "SQL_VARBINARY" "SQL_LONGVARBINARY" "SQL_DATE"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_TIME" "SQL_TIMESTAMP" "SQL_TYPE_DATE" "SQL_TYPE_TIME"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_TYPE_TIMESTAMP" "SQL_BEST_ROWID" "SQL_ROWVER"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_SCOPE_CURROW" "SQL_SCOPE_TRANSACTION" "SQL_SCOPE_SESSION"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_NO_NULLS" "SQL_NULLABLE" "SQL_INDEX_UNIQUE"
</span><span class="comment-delimiter">;        </span><span class="comment">"SQL_INDEX_ALL" "SQL_ENSURE" "SQL_QUICK"
</span><span class="comment-delimiter">;        </span><span class="comment">"X509_PURPOSE_SSL_CLIENT" "X509_PURPOSE_SSL_SERVER"
</span><span class="comment-delimiter">;        </span><span class="comment">"X509_PURPOSE_NS_SSL_SERVER" "X509_PURPOSE_SMIME_SIGN"
</span><span class="comment-delimiter">;        </span><span class="comment">"X509_PURPOSE_SMIME_ENCRYPT" "X509_PURPOSE_CRL_SIGN"
</span><span class="comment-delimiter">;        </span><span class="comment">"X509_PURPOSE_ANY" "PKCS7_DETACHED" "PKCS7_TEXT"
</span><span class="comment-delimiter">;        </span><span class="comment">"PKCS7_NOINTERN" "PKCS7_NOVERIFY" "PKCS7_NOCHAIN"
</span><span class="comment-delimiter">;        </span><span class="comment">"PKCS7_NOCERTS" "PKCS7_NOATTR" "PKCS7_BINARY" "PKCS7_NOSIGS"
</span><span class="comment-delimiter">;        </span><span class="comment">"OPENSSL_PKCS1_PADDING" "OPENSSL_SSLV23_PADDING"
</span><span class="comment-delimiter">;        </span><span class="comment">"OPENSSL_NO_PADDING" "OPENSSL_PKCS1_OAEP_PADDING"
</span><span class="comment-delimiter">;        </span><span class="comment">"ORA_BIND_INOUT" "ORA_BIND_IN" "ORA_BIND_OUT"
</span><span class="comment-delimiter">;        </span><span class="comment">"ORA_FETCHINTO_ASSOC" "ORA_FETCHINTO_NULLS"
</span><span class="comment-delimiter">;        </span><span class="comment">"PREG_PATTERN_ORDER" "PREG_SET_ORDER" "PREG_SPLIT_NO_EMPTY"
</span><span class="comment-delimiter">;        </span><span class="comment">"PREG_SPLIT_DELIM_CAPTURE"
</span><span class="comment-delimiter">;        </span><span class="comment">"PGSQL_ASSOC" "PGSQL_NUM" "PGSQL_BOTH"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_COPIES" "PRINTER_MODE" "PRINTER_TITLE"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_DEVICENAME" "PRINTER_DRIVERVERSION"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_RESOLUTION_Y" "PRINTER_RESOLUTION_X" "PRINTER_SCALE"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_BACKGROUND_COLOR" "PRINTER_PAPER_LENGTH"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_PAPER_WIDTH" "PRINTER_PAPER_FORMAT"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_FORMAT_CUSTOM" "PRINTER_FORMAT_LETTER"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_FORMAT_LEGAL" "PRINTER_FORMAT_A3" "PRINTER_FORMAT_A4"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_FORMAT_A5" "PRINTER_FORMAT_B4" "PRINTER_FORMAT_B5"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_FORMAT_FOLIO" "PRINTER_ORIENTATION"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_ORIENTATION_PORTRAIT" "PRINTER_ORIENTATION_LANDSCAPE"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_TEXT_COLOR" "PRINTER_TEXT_ALIGN" "PRINTER_TA_BASELINE"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_TA_BOTTOM" "PRINTER_TA_TOP" "PRINTER_TA_CENTER"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_TA_LEFT" "PRINTER_TA_RIGHT" "PRINTER_PEN_SOLID"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_PEN_DASH" "PRINTER_PEN_DOT" "PRINTER_PEN_DASHDOT"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_PEN_DASHDOTDOT" "PRINTER_PEN_INVISIBLE"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_BRUSH_SOLID" "PRINTER_BRUSH_CUSTOM"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_BRUSH_DIAGONAL" "PRINTER_BRUSH_CROSS"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_BRUSH_DIAGCROSS" "PRINTER_BRUSH_FDIAGONAL"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_BRUSH_HORIZONTAL" "PRINTER_BRUSH_VERTICAL"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_FW_THIN" "PRINTER_FW_ULTRALIGHT" "PRINTER_FW_LIGHT"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_FW_NORMAL" "PRINTER_FW_MEDIUM" "PRINTER_FW_BOLD"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_FW_ULTRABOLD" "PRINTER_FW_HEAVY" "PRINTER_ENUM_LOCAL"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_ENUM_NAME" "PRINTER_ENUM_SHARED"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_ENUM_DEFAULT" "PRINTER_ENUM_CONNECTIONS"
</span><span class="comment-delimiter">;        </span><span class="comment">"PRINTER_ENUM_NETWORK" "PRINTER_ENUM_REMOTE" "PSPELL_FAST"
</span><span class="comment-delimiter">;        </span><span class="comment">"PSPELL_NORMAL" "PSPELL_BAD_SPELLERS" "PSPELL_RUN_TOGETHER"
</span><span class="comment-delimiter">;        </span><span class="comment">"SID" "SID" "AF_UNIX" "AF_INET" "SOCK_STREAM" "SOCK_DGRAM"
</span><span class="comment-delimiter">;        </span><span class="comment">"SOCK_RAW" "SOCK_SEQPACKET" "SOCK_RDM" "MSG_OOB" "MSG_WAITALL"
</span><span class="comment-delimiter">;        </span><span class="comment">"MSG_PEEK" "MSG_DONTROUTE" "SO_DEBUG" "SO_REUSEADDR"
</span><span class="comment-delimiter">;        </span><span class="comment">"SO_KEEPALIVE" "SO_DONTROUTE" "SO_LINGER" "SO_BROADCAST"
</span><span class="comment-delimiter">;        </span><span class="comment">"SO_OOBINLINE" "SO_SNDBUF" "SO_RCVBUF" "SO_SNDLOWAT"
</span><span class="comment-delimiter">;        </span><span class="comment">"SO_RCVLOWAT" "SO_SNDTIMEO" "SO_RCVTIMEO" "SO_TYPE" "SO_ERROR"
</span><span class="comment-delimiter">;        </span><span class="comment">"SOL_SOCKET" "PHP_NORMAL_READ" "PHP_BINARY_READ"
</span><span class="comment-delimiter">;        </span><span class="comment">"PHP_SYSTEM_READ" "SOL_TCP" "SOL_UDP" "MOD_COLOR" "MOD_MATRIX"
</span><span class="comment-delimiter">;        </span><span class="comment">"TYPE_PUSHBUTTON" "TYPE_MENUBUTTON" "BSHitTest" "BSDown"
</span><span class="comment-delimiter">;        </span><span class="comment">"BSOver" "BSUp" "OverDowntoIdle" "IdletoOverDown"
</span><span class="comment-delimiter">;        </span><span class="comment">"OutDowntoIdle" "OutDowntoOverDown" "OverDowntoOutDown"
</span><span class="comment-delimiter">;        </span><span class="comment">"OverUptoOverDown" "OverUptoIdle" "IdletoOverUp" "ButtonEnter"
</span><span class="comment-delimiter">;        </span><span class="comment">"ButtonExit" "MenuEnter" "MenuExit" "XML_ERROR_NONE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_NO_MEMORY" "XML_ERROR_SYNTAX"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_NO_ELEMENTS" "XML_ERROR_INVALID_TOKEN"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_UNCLOSED_TOKEN" "XML_ERROR_PARTIAL_CHAR"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_TAG_MISMATCH" "XML_ERROR_DUPLICATE_ATTRIBUTE"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_JUNK_AFTER_DOC_ELEMENT" "XML_ERROR_PARAM_ENTITY_REF"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_UNDEFINED_ENTITY" "XML_ERROR_RECURSIVE_ENTITY_REF"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_ASYNC_ENTITY" "XML_ERROR_BAD_CHAR_REF"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_BINARY_ENTITY_REF"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_ATTRIBUTE_EXTERNAL_ENTITY_REF"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_MISPLACED_XML_PI" "XML_ERROR_UNKNOWN_ENCODING"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_INCORRECT_ENCODING"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_UNCLOSED_CDATA_SECTION"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_ERROR_EXTERNAL_ENTITY_HANDLING" "XML_OPTION_CASE_FOLDING"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_OPTION_TARGET_ENCODING" "XML_OPTION_SKIP_TAGSTART"
</span><span class="comment-delimiter">;        </span><span class="comment">"XML_OPTION_SKIP_WHITE" "YPERR_BADARGS" "YPERR_BADDB"
</span><span class="comment-delimiter">;        </span><span class="comment">"YPERR_BUSY" "YPERR_DOMAIN" "YPERR_KEY" "YPERR_MAP"
</span><span class="comment-delimiter">;        </span><span class="comment">"YPERR_NODOM" "YPERR_NOMORE" "YPERR_PMAP" "YPERR_RESRC"
</span><span class="comment-delimiter">;        </span><span class="comment">"YPERR_RPC" "YPERR_YPBIND" "YPERR_YPERR" "YPERR_YPSERV"
</span><span class="comment-delimiter">;        </span><span class="comment">"YPERR_VERS" "FORCE_GZIP" "FORCE_DEFLATE"
</span>
       <span class="comment-delimiter">;; </span><span class="comment">PEAR constants
</span><span class="comment-delimiter">;        </span><span class="comment">"PEAR_ERROR_RETURN" "PEAR_ERROR_PRINT" "PEAR_ERROR_TRIGGER"
</span><span class="comment-delimiter">;        </span><span class="comment">"PEAR_ERROR_DIE" "PEAR_ERROR_CALLBACK" "OS_WINDOWS" "OS_UNIX"
</span><span class="comment-delimiter">;        </span><span class="comment">"PEAR_OS" "DB_OK" "DB_ERROR" "DB_ERROR_SYNTAX"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_CONSTRAINT" "DB_ERROR_NOT_FOUND"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_ALREADY_EXISTS" "DB_ERROR_UNSUPPORTED"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_MISMATCH" "DB_ERROR_INVALID" "DB_ERROR_NOT_CAPABLE"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_TRUNCATED" "DB_ERROR_INVALID_NUMBER"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_INVALID_DATE" "DB_ERROR_DIVZERO"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_NODBSELECTED" "DB_ERROR_CANNOT_CREATE"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_CANNOT_DELETE" "DB_ERROR_CANNOT_DROP"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_NOSUCHTABLE" "DB_ERROR_NOSUCHFIELD"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_NEED_MORE_DATA" "DB_ERROR_NOT_LOCKED"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_VALUE_COUNT_ON_ROW" "DB_ERROR_INVALID_DSN"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_ERROR_CONNECT_FAILED" "DB_WARNING" "DB_WARNING_READ_ONLY"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_PARAM_SCALAR" "DB_PARAM_OPAQUE" "DB_BINMODE_PASSTHRU"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_BINMODE_RETURN" "DB_BINMODE_CONVERT" "DB_FETCHMODE_DEFAULT"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_FETCHMODE_ORDERED" "DB_FETCHMODE_ASSOC"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_FETCHMODE_FLIPPED" "DB_GETMODE_ORDERED" "DB_GETMODE_ASSOC"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_GETMODE_FLIPPED" "DB_TABLEINFO_ORDER"
</span><span class="comment-delimiter">;        </span><span class="comment">"DB_TABLEINFO_ORDERTABLE" "DB_TABLEINFO_FULL"
</span>
       )))
  <span class="doc">"PHP constants."</span>)

(<span class="keyword">defconst</span> <span class="variable-name">php-keywords</span>
  (<span class="keyword">eval-when-compile</span>
    (regexp-opt
     <span class="comment-delimiter">;; </span><span class="comment">"class", "new" and "extends" get special treatment
</span>     <span class="comment-delimiter">;; </span><span class="comment">"case" and "default" get special treatment elsewhere
</span>     '(<span class="string">"and"</span> <span class="string">"as"</span> <span class="string">"break"</span> <span class="string">"continue"</span> <span class="string">"declare"</span> <span class="string">"do"</span> <span class="string">"echo"</span> <span class="string">"else"</span> <span class="string">"elseif"</span>
       <span class="string">"endfor"</span> <span class="string">"endforeach"</span> <span class="string">"endif"</span> <span class="string">"endswitch"</span> <span class="string">"endwhile"</span> <span class="string">"exit"</span>
       <span class="string">"extends"</span> <span class="string">"for"</span> <span class="string">"foreach"</span> <span class="string">"global"</span> <span class="string">"if"</span> <span class="string">"include"</span> <span class="string">"include_once"</span>
       <span class="string">"next"</span> <span class="string">"or"</span> <span class="string">"require"</span> <span class="string">"require_once"</span> <span class="string">"return"</span> <span class="string">"static"</span> <span class="string">"switch"</span>
       <span class="string">"then"</span> <span class="string">"var"</span> <span class="string">"while"</span> <span class="string">"xor"</span> <span class="string">"throw"</span> <span class="string">"catch"</span> <span class="string">"try"</span>
       <span class="string">"instanceof"</span> <span class="string">"catch all"</span> <span class="string">"finally"</span>)))
  <span class="doc">"PHP keywords."</span>)

(<span class="keyword">defconst</span> <span class="variable-name">php-identifier</span>
  (<span class="keyword">eval-when-compile</span>
    '<span class="string">"[a-zA-Z\_\x7f-\xff][a-zA-Z0-9\_\x7f-\xff]*"</span>)
  <span class="doc">"Characters in a PHP identifier."</span>)

(<span class="keyword">defconst</span> <span class="variable-name">php-types</span>
  (<span class="keyword">eval-when-compile</span>
    (regexp-opt '(<span class="string">"array"</span> <span class="string">"bool"</span> <span class="string">"boolean"</span> <span class="string">"char"</span> <span class="string">"const"</span> <span class="string">"double"</span> <span class="string">"float"</span>
                  <span class="string">"int"</span> <span class="string">"integer"</span> <span class="string">"long"</span> <span class="string">"mixed"</span> <span class="string">"object"</span> <span class="string">"real"</span>
                  <span class="string">"string"</span>)))
  <span class="doc">"PHP types."</span>)

(<span class="keyword">defconst</span> <span class="variable-name">php-superglobals</span>
  (<span class="keyword">eval-when-compile</span>
    (regexp-opt '(<span class="string">"_GET"</span> <span class="string">"_POST"</span> <span class="string">"_COOKIE"</span> <span class="string">"_SESSION"</span> <span class="string">"_ENV"</span> <span class="string">"GLOBALS"</span>
                  <span class="string">"_SERVER"</span> <span class="string">"_FILES"</span> <span class="string">"_REQUEST"</span>)))
  <span class="doc">"PHP superglobal variables."</span>)</pre><hr /><pre>
<span class="comment-delimiter">;; </span><span class="comment">Set up font locking
</span>(<span class="keyword">defconst</span> <span class="variable-name">php-font-lock-keywords-1</span>
  (list
   <span class="comment-delimiter">;; </span><span class="comment">Fontify constants
</span>   (cons
    (concat <span class="string">"[</span><span class="string"><span class="negation-char">^</span></span><span class="string">_$]?\\&lt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">"</span> php-constants <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\&gt;[</span><span class="string"><span class="negation-char">^</span></span><span class="string">_]?"</span>)
    '(1 font-lock-constant-face))

   <span class="comment-delimiter">;; </span><span class="comment">Fontify keywords
</span>   (cons
    (concat <span class="string">"[</span><span class="string"><span class="negation-char">^</span></span><span class="string">_$]?\\&lt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">"</span> php-keywords <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\&gt;[</span><span class="string"><span class="negation-char">^</span></span><span class="string">_]?"</span>)
    '(1 font-lock-keyword-face))

   <span class="comment-delimiter">;; </span><span class="comment">Fontify keywords and targets, and case default tags.
</span>   (list <span class="string">"\\&lt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">break</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">case</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">continue</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\&gt;\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">-?\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?"</span>
         '(1 font-lock-keyword-face) '(2 font-lock-constant-face t t))
   <span class="comment-delimiter">;; </span><span class="comment">This must come after the one for keywords and targets.
</span>   '(<span class="string">":"</span> (<span class="string">"^\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+\\s-+$"</span>
          (beginning-of-line) (end-of-line)
          (1 font-lock-constant-face)))

   <span class="comment-delimiter">;; </span><span class="comment">treat 'print' as keyword only when not used like a function name
</span>   '(<span class="string">"\\&lt;print\\s-*("</span> . php-default-face)
   '(<span class="string">"\\&lt;print\\&gt;"</span> . font-lock-keyword-face)

   <span class="comment-delimiter">;; </span><span class="comment">Fontify PHP tag
</span>   (cons php-tags-key font-lock-preprocessor-face)

   <span class="comment-delimiter">;; </span><span class="comment">Fontify ASP-style tag
</span>   '(<span class="string">"&lt;\\%</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">=</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?"</span> . font-lock-preprocessor-face)
   '(<span class="string">"\\%&gt;"</span> . font-lock-preprocessor-face)

   )
  <span class="doc">"Subdued level highlighting for PHP mode."</span>)

(<span class="keyword">defconst</span> <span class="variable-name">php-font-lock-keywords-2</span>
  (append
   php-font-lock-keywords-1
   (list

    <span class="comment-delimiter">;; </span><span class="comment">class declaration
</span>    '(<span class="string">"\\&lt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">class</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">interface</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">?"</span>
      (1 font-lock-keyword-face) (2 font-lock-type-face nil t))
    <span class="comment-delimiter">;; </span><span class="comment">handle several words specially, to include following word,
</span>    <span class="comment-delimiter">;; </span><span class="comment">thereby excluding it from unknown-symbol checks later
</span>    <span class="comment-delimiter">;; </span><span class="comment">FIX to handle implementing multiple
</span>    <span class="comment-delimiter">;; </span><span class="comment">currently breaks on "class Foo implements Bar, Baz"
</span>    '(<span class="string">"\\&lt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">new</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">extends</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">implements</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+\\$?</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">"</span>
      (1 font-lock-keyword-face) (2 font-lock-type-face))

    <span class="comment-delimiter">;; </span><span class="comment">function declaration
</span>    '(<span class="string">"\\&lt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">function</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+&amp;?</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*("</span>
      (1 font-lock-keyword-face)
      (2 font-lock-function-name-face nil t))

    <span class="comment-delimiter">;; </span><span class="comment">class hierarchy
</span>    '(<span class="string">"\\&lt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">self</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">parent</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\&gt;"</span> (1 font-lock-constant-face nil nil))

    <span class="comment-delimiter">;; </span><span class="comment">method and variable features
</span>    '(<span class="string">"\\&lt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">private</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">protected</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">public</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+\\$?\\sw+"</span>
      (1 font-lock-keyword-face))

    <span class="comment-delimiter">;; </span><span class="comment">method features
</span>    '(<span class="string">"^\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">abstract</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">static</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">final</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+\\$?\\sw+"</span>
      (1 font-lock-keyword-face))

    <span class="comment-delimiter">;; </span><span class="comment">variable features
</span>    '(<span class="string">"^\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">static</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">const</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+\\$?\\sw+"</span>
      (1 font-lock-keyword-face))
    ))
  <span class="doc">"Medium level highlighting for PHP mode."</span>)

(<span class="keyword">defconst</span> <span class="variable-name">php-font-lock-keywords-3</span>
  (append
   php-font-lock-keywords-2
   (list

    <span class="comment-delimiter">;; </span><span class="comment">&lt;word&gt; or &lt;/word&gt; for HTML
</span>    <span class="comment-delimiter">;;</span><span class="comment">'("&lt;/?\\sw+[</span><span class="comment"><span class="negation-char">^</span></span><span class="comment">&gt; ]*&gt;" . font-lock-constant-face)
</span>    <span class="comment-delimiter">;;</span><span class="comment">'("&lt;/?\\sw+[</span><span class="comment"><span class="negation-char">^</span></span><span class="comment">&gt;]*" . font-lock-constant-face)
</span>    <span class="comment-delimiter">;;</span><span class="comment">'("&lt;!DOCTYPE" . font-lock-constant-face)
</span>    '(<span class="string">"&lt;/?[a-z!:]+"</span> . font-lock-constant-face)

    <span class="comment-delimiter">;; </span><span class="comment">HTML &gt;
</span>    '(<span class="string">"&lt;[</span><span class="string"><span class="negation-char">^</span></span><span class="string">&gt;]*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">&gt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">"</span> (1 font-lock-constant-face))

    <span class="comment-delimiter">;; </span><span class="comment">HTML tags
</span>    '(<span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">&lt;[a-z]+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">[[:space:]]+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">[a-z:]+=</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">[</span><span class="string"><span class="negation-char">^</span></span><span class="string">&gt;]*?"</span> (1 font-lock-constant-face) (2 font-lock-constant-face) )
    '(<span class="string">"\"[[:space:]]+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">[a-z:]+=</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">"</span> (1 font-lock-constant-face))

    <span class="comment-delimiter">;; </span><span class="comment">HTML entities
</span>    <span class="comment-delimiter">;;</span><span class="comment">'("&amp;\\w+;" . font-lock-variable-name-face)
</span>
    <span class="comment-delimiter">;; </span><span class="comment">warn about '$' immediately after -&gt;
</span>    '(<span class="string">"\\$\\sw+-&gt;\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\$</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">"</span>
      (1 font-lock-warning-face) (2 php-default-face))

    <span class="comment-delimiter">;; </span><span class="comment">warn about $word.word -- it could be a valid concatenation,
</span>    <span class="comment-delimiter">;; </span><span class="comment">but without any spaces we'll assume $word-&gt;word was meant.
</span>    '(<span class="string">"\\$\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\.</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\sw"</span>
      1 font-lock-warning-face)

    <span class="comment-delimiter">;; </span><span class="comment">Warn about ==&gt; instead of =&gt;
</span>    '(<span class="string">"==+&gt;"</span> . font-lock-warning-face)

    <span class="comment-delimiter">;; </span><span class="comment">exclude casts from bare-word treatment (may contain spaces)
</span>    `(,(concat <span class="string">"(\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">"</span> php-types <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*)"</span>)
      1 font-lock-type-face)

    <span class="comment-delimiter">;; </span><span class="comment">PHP5: function declarations may contain classes as parameters type
</span>    `(,(concat <span class="string">"[(,]\\s-*</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-+&amp;?\\$\\sw+\\&gt;"</span>)
      1 font-lock-type-face)

    <span class="comment-delimiter">;; </span><span class="comment">Fontify variables and function calls
</span>    '(<span class="string">"\\$</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">this</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">|</span></span><span class="string">that</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\W"</span> (1 font-lock-constant-face nil nil))
    `(,(concat <span class="string">"\\$</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">"</span> php-superglobals <span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\W"</span>)
      (1 font-lock-constant-face nil nil)) <span class="comment-delimiter">;; </span><span class="comment">$_GET &amp; co
</span>    '(<span class="string">"\\$</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">"</span> (1 font-lock-variable-name-face)) <span class="comment-delimiter">;; </span><span class="comment">$variable
</span>    '(<span class="string">"-&gt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">"</span> (1 font-lock-variable-name-face t t)) <span class="comment-delimiter">;; </span><span class="comment">-&gt;variable
</span>    '(<span class="string">"-&gt;</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">\\s-*("</span> . (1 php-default-face t t)) <span class="comment-delimiter">;; </span><span class="comment">-&gt;function_call
</span>    '(<span class="string">"</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">::\\sw+\\s-*(?"</span> . (1 font-lock-type-face)) <span class="comment-delimiter">;; </span><span class="comment">class::member
</span>    '(<span class="string">"::</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">(</span></span><span class="string">\\sw+\\&gt;[</span><span class="string"><span class="negation-char">^</span></span><span class="string">(]</span><span class="string"><span class="regexp-grouping-backslash">\\</span></span><span class="string"><span class="regexp-grouping-construct">)</span></span><span class="string">"</span> . (1 php-default-face)) <span class="comment-delimiter">;; </span><span class="comment">class::constant
</span>    '(<span class="string">"\\&lt;\\sw+\\s-*[[(]"</span> . php-default-face) <span class="comment-delimiter">;; </span><span class="comment">word( or word[
</span>    '(<span class="string">"\\&lt;[0-9]+"</span> . php-default-face) <span class="comment-delimiter">;; </span><span class="comment">number (also matches word)
</span>
    <span class="comment-delimiter">;; </span><span class="comment">Warn on any words not already fontified
</span>    '(<span class="string">"\\&lt;\\sw+\\&gt;"</span> . font-lock-warning-face)

    ))
  <span class="doc">"Gauchy level highlighting for PHP mode."</span>)

(<span class="keyword">provide</span> '<span class="constant">php-mode</span>)

<span class="comment-delimiter">;;; </span><span class="comment">php-mode.el ends here
</span></pre>
  </body>
</html>
