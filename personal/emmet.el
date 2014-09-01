;;; emmet.el --- An Emmet-mode configuration
;;; Commentary:
;;  none

;;; Code:
(require 'emmet-mode)

(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'web-mode-hook  'emmet-mode)
(add-hook 'scss-mode-hook 'emmet-mode)
(add-hook 'sass-mode-hook 'emmet-mode)
(setq emmet-preview-default nil)

;; Unbind expand-line from C-j, use C-RET instead
(define-key emmet-mode-keymap (kbd "C-j") nil)

(provide 'emmet)
;;; emmet.el ends here
