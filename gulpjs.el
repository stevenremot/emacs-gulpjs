;;; gulpjs.el --- Node's gulp support fur Emacs

;; Copyright (C) 2014 Steven Rémot

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

;; (require 'gulpjs)

;; Or just put an autoload for the main entry point:

;; (autoload 'gulpjs-start-task "gulpjs" "STart a gulp task." t)

;; Usage:

;; When you are visiting a file in a project using gulp, simply use the
;; command `M-x gulpjs-start-task`, which will prompt you for the task to
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

(require 'ido)

;;; Code:
(defgroup gulpjs
  '()
  "Node's gulp support."
  :group 'tools)

(defcustom gulpjs-executable "gulp"
  "Path to gulp executable."
  :type 'string
  :group 'gulpjs)

(defcustom gulpjs-file-name "gulpfile.js"
  "File name of gulp file."
  :type 'string
  :group 'gulpjs)

(defcustom gulpjs-buffer-name "*gulp*"
  "Buffer name for gulpjs output buffer."
  :type 'string
  :group 'gulpjs)

(defvar gulpjs-task ""
  "Gulp task run in the current buffer.")

(defvar gulpjs-directory ""
  "Directory for current gulp task.")

(defun gulpjs-get-root (directory)
  "Return the parent directory containing the gulpfile.

Start to look in DIRECTORY.

Return nil of no gulp file has been found."
  (locate-dominating-file directory gulpjs-file-name))

(defun gulpjs-open-buffer ()
  "Open a buffer for gulpjs output."
  (get-buffer-create gulpjs-buffer-name))

(defun gulpjs-process-sentinel (process event)
  "Watch the modifications for gulp PROCESS.

EVENT is the proces' status change."
  (when (string-match-p "exited abnormally" event)
    (message (propertize "Gulp process stopped unexpectedly" 'face 'error))
    (switch-to-buffer-other-window (gulpjs-open-buffer))))

(defun gulpjs-create-process-for-task (file-name task)
  "Launch the gulp process in FILE-NAME for TASK."
  (setq default-directory (gulpjs-get-root (if (file-directory-p file-name)
                                               file-name
                                             (file-name-directory file-name)))
        gulpjs-task task
        gulpjs-directory default-directory)
  (if default-directory
      (let ((process (start-process "gulpjs" (current-buffer) gulpjs-executable task)))
        (set-process-sentinel process 'gulpjs-process-sentinel)
        (gulpjs-mode))
    (setq default-directory "")
    (error "Cannot find gulp file")
    (kill-buffer)))

(defun gulpjs-list-all-gulp-tasks ()
  "List all the gulp taks in simple format."
  (split-string
   (shell-command-to-string
    "gulp --tasks-simple")
   "\n"
   t))

;;;###autoload
(defun gulpjs-start-task ()
  "Start a gulp task in a specified buffer.

TASK is a string specifying the task to start."
  (interactive)
  (let ((task (ido-completing-read "Enter a gulp task : " (gulpjs-list-all-gulp-tasks)))
        (file-name (buffer-file-name))
        (buffer (gulpjs-open-buffer)))
    (with-current-buffer buffer
      (gulpjs-create-process-for-task file-name task))
    (switch-to-buffer-other-window buffer)))

(defun gulpjs-restart-task ()
  "Restart the gulp task run in the current buffer."
  (interactive)
  (with-current-buffer (gulpjs-open-buffer)
    (gulpjs-create-process-for-task gulpjs-directory gulpjs-task)))

;;;;;;;
;; Mode
;;;;;;;

(defvar gulpjs-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "g") 'gulpjs-restart-task)
    map)
  "Keymap for `gulpjs-mode'.")

(define-derived-mode gulpjs-mode compilation-mode "gulpjs"
  "Major mode for node's gulp execution.
\\{gulpjs-mode-map}")


(provide 'gulpjs)

;;; gulpjs.el ends here
