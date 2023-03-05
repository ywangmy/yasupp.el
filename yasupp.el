;;; yasupp.el --- A supplementary package for Yasnippet

;; Copyright (C) 2022-2023 ywangmy

;; Author: ywangmy <https://github.com/ywangmy>
;; Maintainer: ywangmy <ycwangmy@gmail.com>
;; Created: December 31, 2022
;; Modified: December 31, 2022
;; Version: 0.1
;; Keywords: yasnippet, tex
;; URL: https://github.com/ywangmy/yasupp
;; Package-Requires: ((auctex "13.1") (yasnippet "0.14.0"))

;;; Commentary:
;;
;; This package supplements yasnippet.el with several functions useful for
;; writing snippets that manipulate region and prefix expressions.

;;; Code:

(defgroup yasupp nil
  "A supplementary package for Yasnippet."
  :prefix "yasp-"
  :group 'yasnippet)

;;;###autoload
(define-minor-mode yasp-minor-mode
  "Minor mode for yasupp."
  :lighter nil
  (if yasp-minor-mode
      nil
    nil)
  )

(defun yasp-selected-current ()
  "Select the expression under or adjacent to the cursor.

Activate when `yasp-minor-mode' is 1 and `region-active-p' is nil.

Return value: t.

Usage:

- cannot be used in 'condition:', since the yasnippet implementation save the
cursor position when evaluating conditions.
- shoulde be called directly."
  (interactive)
  (unless (or (not yasp-minor-mode) (region-active-p))
    (let* ((start (point)) (end (point))
           (syntaxes "\\w_")
           )
      (skip-syntax-backward syntaxes)
      (setq start (point))
      (skip-syntax-forward syntaxes)
      (setq end (point))
      (unless (= start end)
        (goto-char start)
        (set-mark-command ())
        (goto-char end)
        )
      )
    )
  t
  )

(defun yasp-selected-left ()
  "Select the balanced expression to the left of the cursor.

This can be used for expanding fraction. Activate when `yasp-minor-mode' is 1
and `region-active-p' is nil.

See `yasp-selected-current'."
  (interactive)
  (unless (or (not yasp-minor-mode) (region-active-p))
    (let* ((start (point)) (end (point))
           )
      (save-excursion
        (skip-syntax-backward "w")
        (setq start (point))
      )
      (when (not (= start end))
        (backward-sexp)
        (setq start (point))
        (unless (= start end)
          (set-mark-command ())
          (goto-char end)
          )
        )
      )
    )
  t
  )

(provide 'yasupp)
;;; yasupp.el ends here
