;;; gulpjs-helm.el --- Node's gulp helm support fur Emacs

;; Copyright (C) 2014 Steven Rémot
;; Copyright (C) 2015 zilongshanren

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Author: Steven Rémot
;; Version: 0.0.1

;;; Commentary:

;; This package offers a basic support of gulp, the javascript streaming
;; build system, for Emacs.

;; Installation:

;; First, you should put the gulpjs directory in your load path:

;; (add-to-list 'load-path "<path-to-gulpjs-dir>")

;; Then, you can either require the whole file in your *init.el*:

;; (require 'gulpjs-helm)

;; Usage:

;; When you are visiting a file in a project using gulp, simply use the
;; command `M-x gulpjs-helm-start-task`, which will prompt you for the task to
;; start.  gulp process will be started, its output redirected to the
;; buffer named `*gulp*` by default.

;; You can restart a stopped process by either pressing *g* in the gulp
;; buffer, or using `M-x gulpjs-restart-task`.

;;  State of the project:

;; This package is a tiny code that I wrote to fit my specific and very
;; basic use of gulp.  If you think some useful functionality could be
;; added, feel free to open an issue so we can talk about it.

;; License:

;; This code is released under the GPL v3. See *COPYING* for more
;; details.

(require 'helm)
(require 'gulpjs)

(defun gulpjs-start-task-with-name (task)
  "Start a gulp task in a specified buffer.

TASK is a string specifying the task to start."
  (let ((file-name (buffer-file-name))
        (buffer (gulpjs-open-buffer)))
    (with-current-buffer buffer
      (gulpjs-create-process-for-task file-name task))
    (switch-to-buffer-other-window buffer)))

;;;###autoload
(defun gulpjs-helm-start-tasks ()
  "Select an gulps task and start it."
  (interactive)
  (helm :sources
        '(((name . "Gulp Tasks")
           (candidates . gulpjs-list-all-gulp-tasks)
           (action . gulpjs-start-task-with-name)))))

(provide 'gulpjs-helm)

;;; gulpjs-helm.el ends here
