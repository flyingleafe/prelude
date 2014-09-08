;;; config.el -- Personal config of glorious Me, fLf

;;; Commentary:
;;  All you see here is just the pathetic attempt
;;  of a simple-minded person to hold the
;;  vast, enormous power of the mighty Emacs

;;; Code:

;; ============= Environment setup ============= ;;

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (setenv "EDITOR" "/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10.9/emacsclient"))


;; ============= Things to survive ============= ;;

;; Super-useful Hyper key
(defvar ns-function-modifier 'hyper)

;; Multicursors bindings
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Helm is the thing I wanna have everywhere
(helm-mode 1)

;; And I don't want the Projectile buffer to
;; fire automatically
(global-set-key (kbd "H-p") 'helm-projectile)
(define-key prelude-mode-map (kbd "C-c h") 'helm-mini)


;; ============ Configuration editing =============== ;;

;; Access config.Eli
(defvar flf-config (expand-file-name "~/.emacs.d/personal/config.el"))
(defvar main-config (expand-file-name "~/.emacs.d/init.el"))

(defun flf-open-config ()
  "Open .emacs in other window."
  (interactive)
  (find-file flf-config))

;; Reload configuration
(defun flf-reload-config ()
  "Reload .emacs configuration."
  (interactive)
  (load-file main-config))

(global-set-key (kbd "H-e") 'flf-open-config)
(global-set-key (kbd "H-r") 'flf-reload-config)


;; =============== Styling modes =============== ;;

(require 'scss-mode)
(require 'sass-mode)

;; Auto-compile Sass files
(add-hook 'sass-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'scss-compile-maybe nil t)))


;; =============== Web mode ==================== ;;

;; Disable Whitespace and flycheck, they are
;; usually useless during markup editing
(add-hook 'web-mode-hook
          (lambda ()
            (whitespace-mode -1)
            (flycheck-mode -1)))

;; ============= Javascript mode =============== ;;

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(js2r-add-keybindings-with-prefix "C-c C-r")

;; ============= Org mode customs ============== ;;

;; Habits tracking
(add-to-list 'org-modules "org-habits")

;; Folders and files definition
(setq org-directory (expand-file-name "~/Org"))
(defvar flf-todo-folder (format "%s/%s" org-directory "Todo"))
(defvar flf-main-todo   (format "%s/%s" flf-todo-folder "HotTodo.org"))
(defvar flf-habits      (format "%s/%s" flf-todo-folder "Habits.org"))

;; MobileOrg setup
(setq org-mobile-directory "~/Dropbox/Приложения/MobileOrg")
(setq org-mobile-inbox-for-pull (format "%s/%s" org-directory "Inbox.org"))

;; Agenda setup
(add-to-list 'org-agenda-files flf-todo-folder)

;; File opening
(defun flf-open-hot-todo ()
  (interactive)
  (find-file flf-main-todo))

(defun flf-open-habits ()
  (interactive)
  (find-file flf-habits))

;; Keybindings
(global-set-key (kbd "H-l") 'org-store-link)
(global-set-key (kbd "H-c") 'org-capture)
(global-set-key (kbd "H-a") 'org-agenda)
(global-set-key (kbd "H-b") 'org-iswitchb)
(global-set-key (kbd "H-t") 'flf-open-hot-todo)
(global-set-key (kbd "H-h") 'flf-open-habits)

;; Sub-todos proper handling
(setq org-hierarchical-todo-statistics 'nil)

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; Logging
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))


;; =============== Look and feel =============== ;;

;; Color theme
(load-theme 'brin t)


;; =========== End of configuration ============ ;;
(provide 'config)
;;; config.el ends here
