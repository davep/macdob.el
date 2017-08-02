;;; macdob.el --- Report a Mac's "date of birth"
;; Copyright 2017 by Dave Pearson <davep@davep.org>

;; Author: Dave Pearson <davep@davep.org>
;; Version: 1.0
;; Keywords: convenience
;; URL: https://github.com/davep/macdob.el

;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; macdob.el provides a simple command that reports on a Mac's "date of
;; birth". That is, it tries to report when the OS on the machine was first
;; set up.

;;; Code:

(defconst macdob-setup-done-file "/var/db/.AppleSetupDone"
  "File that gives a clue as to when the setup was done.")

(defgroup macdob nil
  "Get and display the \"date of birth\" of a Mac."
  :group 'convenience
  :prefix "macdob-")

(defcustom macdob-time-format "%F %T%z"
  "Human-readable format for showing the Mac's date of birth."
  :type 'string
  :group 'macdob)

(defun macdob-setup-time ()
  "Get the time stamp of the setup done file."
  (when (file-exists-p macdob-setup-done-file)
    (nth 5 (file-attributes macdob-setup-done-file))))

(defun macdob-formatted-setup-time ()
  "Get the time stamp of the setup done file, as a string."
  (let ((dob (macdob-setup-time)))
    (if dob
        (format-time-string macdob-time-format dob)
      "unknown")))

(defun macdob-mac-p ()
  "Does it look like we're running on a Mac?"
  (eq system-type 'darwin))

;;;###autoload
(defun macdob ()
  "Show the Mac's apparent \"date of birth\".

Or mention that we don't appear to be on a Mac."
  (interactive)
  (if (macdob-mac-p)
      (message "This Mac appears to have been born on %s" (macdob-formatted-setup-time))
    (message "This doesn't look like a Mac!")))

;;;###autoload
(defun macdob-insert ()
  "Insert the Mac's \"date of birth\" into the current buffer."
  (interactive)
  (if (macdob-mac-p)
      (insert (macdob-formatted-setup-time))
    (error "This doesn't look like a Mac!")))

(provide 'macdob)

;;; macdob.el ends here
