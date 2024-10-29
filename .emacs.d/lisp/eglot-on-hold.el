;;; eldoc-on-hold.el --- Summary -*- lexical-binding: t; -*-

;; Copyright 2021 Google LLC
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;      http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.
;;
;; SPDX-License-Identifier: Apache-2.0

;;; Commentary:
;;
;; This package extends eldoc.el to display documentations with a delay.
;;
;; When `global-eldoc-on-hold-mode' is on, eldoc will wait for an extra
;; time of `eldoc-on-hold-delay-interval' seconds to display the message
;; (Note that this is in addition to `eldoc-idle-delay', however `eldoc-idle-delay'
;; delays the calculation of eldoc info, while `eldoc-on-hold-delay-interval'
;; delays the display of the info).
;;
;; An extra command, `eldoc-on-hold-pick-up' is also provided to immediately
;; display the eldoc message.

;;; Code:

(eval-when-compile (require 'eglot))

(defcustom eglot-on-hold-delay-interval 0.5
  "Delayed time to display eglot."
  :group 'eglot-on-hold
  :type 'number)

(defvar eglot-on-hold--msg-timer nil
  "Timer for displaying eglot messages.")
(defvar eglot-on-hold--no-delay-timer nil
  "Timer to reset 'eglot-on-hold--use-timer' after a cancel event.")
(defvar eglot-on-hold--use-timer t
  "Internal variable to keep track of whether we should delay the display.")
(defvar eglot-on-hold--prev-interval nil
  "Internal variable to remember the user's preferred delay time.")

(defun eglot-on-hold--msg (orig-fun cb)
  "Show eglot highlight with a delay.
Used to advice ORIG-FUN, which should be 'eglot-hover-eglot-function', CB is cb "
  (message "in eglot-on-hold--msg")
  (when eglot-on-hold--msg-timer
    (cancel-timer eglot-on-hold--msg-timer)
    (setq eglot-on-hold--msg-timer nil))
  (message "run-with-timer %s, %s" orig-fun eglot-on-hold-delay-interval)
  (setq eglot-on-hold--msg-timer
    (run-with-timer eglot-on-hold-delay-interval nil orig-fun cb))
  )

(defun eglot-on-hold--cancel-timer ()
  "Cancel the delayed eglot display if necessary."
  (when eglot-on-hold--no-delay-timer
    (cancel-timer eglot-on-hold--no-delay-timer)))

(define-minor-mode global-eglot-on-hold-mode
  "Enable global-eglot-on-hold mode."
  :group 'eglot-on-hold
  :global t
  (if global-eglot-on-hold-mode
      (progn
        (setq eglot-on-hold--msg-timer nil)
        (setq eglot-on-hold--no-delay-timer nil)
        (setq eglot-on-hold--use-timer t)
        (setq eglot-on-hold--prev-interval eglot-on-hold-delay-interval)
        (advice-add 'eglot-hover-eldoc-function :around #'eglot-on-hold--msg)
        (add-hook 'post-command-hook #'eglot-on-hold--cancel-timer))
    (advice-remove 'eglot-hover-eldoc-function #'eglot-on-hold--msg)
    (when eglot-on-hold--msg-timer
      (cancel-timer eglot-on-hold--msg-timer))
    (when eglot-on-hold--no-delay-timer
      (cancel-timer eglot-on-hold--no-delay-timer))
    (setq eglot-on-hold--msg-timer nil)
    (setq eglot-on-hold--no-delay-timer nil)
    (setq eglot-on-hold--use-timer t)
    (setq eglot-on-hold-delay-interval eglot-on-hold--prev-interval)
    (remove-hook 'post-command-hook #'eglot-on-hold--cancel-timer)))

(provide 'eglot-on-hold)
;;; eglot-on-hold.el ends here
