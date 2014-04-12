#gulpjs#

##Description##

This package offers a basic support of gulp, the javascript streaming
build system, for Emacs.

##Installation##

First, you should put the gulpjs directory in your load path:

```elisp
(add-to-list 'load-path "<path-to-gulpjs-dir>")
```

Then, you can either require the whole file in your *init.el*:

```elisp
(require 'gulpjs)
```

Or just put an autoload for the main entry point:

```elisp
(autoload 'gulpjs-start-task "gulpjs" "STart a gulp task." t)
```

##Usage##

When you are visiting a file in a project using gulp, simply use the
command `M-x gulpjs-start-task`, which will prompt you for the task to
start.  gulp process will be started, its output redirected to the
buffer named `*gulp*` by default.

You can restart a stopped process by either pressing *g* in the gulp
buffer, or using `M-x gulpjs-restart-task`.

##State of the project##

This package is a tiny code that I wrote to fit my specific and very
basic use of gulp. If you think some useful functionality could be
added, feel free to open an issue so we can talk about it.

##License##

This code is released under the GPL v3. See *COPYING* for more
details.
