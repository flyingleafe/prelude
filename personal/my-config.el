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

(push "~/.virtualenvs/press_env/bin" exec-path)
(setenv "PATH" (concat
                "~/.virtualenvs/press_env/bin" ":"
                (getenv "PATH")))

(server-start)

;; ============= Things to survive ============= ;;

;; Line numbers
(global-nlinum-mode 1)

;; Super-useful Hyper key
(defvar ns-function-modifier 'hyper)
;; and the foo to replace hyper if no function key is present
(defun flf-hyper-kbd (str)
  (if (eq system-type 'darwin)
      (kbd str)
    (kbd (replace-regexp-in-string "H" "C-s" str t))))

;; Multicursors bindings
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Helm is the thing I wanna have everywhere
(helm-mode 1)

;; Yasnippets are awesome
(yas-global-mode 1)

;; And I don't want the Projectile buffer to
;; fire automatically
(global-set-key (flf-hyper-kbd "H-p") 'helm-projectile)
(define-key prelude-mode-map (kbd "C-c h") 'helm-mini)

;; Commenting support
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(global-set-key (kbd "C-c C-/") 'comment-or-uncomment-region-or-line)

;; Turn off Flyspell
(add-hook 'prelude-prog-mode-hook 'turn-off-flyspell)

;; ===================== Tramp ====================== ;;
(setq tramp-default-method "ssh")

;; ============ Configuration editing =============== ;;

;; Access config.Eli
(defvar flf-config (expand-file-name "~/.emacs.d/personal/my-config.el"))
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

(global-set-key (flf-hyper-kbd "H-e") 'flf-open-config)
(global-set-key (flf-hyper-kbd "H-r") 'flf-reload-config)


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

;; JS2 mode enabling
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; JS2-refactor keybindings
(js2r-add-keybindings-with-prefix "C-c C-r")
;; Web-beautify
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "M-s-¬") 'web-beautify-js))

;; ============= Org mode customs ============== ;;

(require 'org-habit)

;; Habits tracking
(add-to-list 'org-modules "org-habits")

;; Folders and files definition
(setq org-directory (expand-file-name "~/Org"))
(defvar flf-todo-folder (format "%s/%s" org-directory "Todo"))
(defvar flf-main-todo   (format "%s/%s" flf-todo-folder "HotTodo.org"))
(defvar flf-habits      (format "%s/%s" flf-todo-folder "Habits.org"))
(defvar flf-schedule    (format "%s/%s" org-directory "Schedule.org"))
(defvar flf-times       (format "%s/%s" org-directory "Times.org"))

;; MobileOrg setup
(setq org-mobile-directory "~/Dropbox/Приложения/MobileOrg")
(setq org-mobile-inbox-for-pull (format "%s/%s" org-directory "Inbox.org"))

;; Agenda setup
(add-to-list 'org-agenda-files flf-todo-folder)
(add-to-list 'org-agenda-files flf-schedule)
(add-to-list 'org-agenda-files flf-times)

;; File opening
(defun flf-open-hot-todo ()
  (interactive)
  (find-file flf-main-todo))

(defun flf-open-habits ()
  (interactive)
  (find-file flf-habits))

(defun flf-open-schedule ()
  (interactive)
  (find-file flf-schedule))

;; Keybindings
(global-set-key (flf-hyper-kbd "H-l") 'org-store-link)
(global-set-key (flf-hyper-kbd "H-c") 'org-capture)
(global-set-key (flf-hyper-kbd "H-a") 'org-agenda)
(global-set-key (flf-hyper-kbd "H-b") 'org-iswitchb)
(global-set-key (flf-hyper-kbd "H-t") 'flf-open-hot-todo)
(global-set-key (flf-hyper-kbd "H-h") 'flf-open-habits)
(global-set-key (flf-hyper-kbd "H-s") 'flf-open-schedule)

;; Sub-todos proper handling
(setq org-hierarchical-todo-statistics 'nil)

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; Loggingq
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))

(setq org-todo-keyword-faces
      '(("WAIT" . "yellow")
        ("LEARNING" . "yellow")
        ("PROMISED" . "yellow")
        ("CANCELED" . (:foreground "blue" :weight bold))))

;; ============= Package control =============== ;;

(defvar flf-pkg-list-file (concat user-emacs-directory ".pkglist.el"))

(defun flf-save-pkg-list ()
  (interactive)
  (with-temp-buffer
    (write-char ?' (current-buffer))
    (prin1 package-activated-list (current-buffer))
    (write-file flf-pkg-list-file)))

(defun flf-restore-packages ()
  (interactive)
  (with-temp-buffer
    (insert-file-contents flf-pkg-list-file)
    (let ((packages-list (eval (read (current-buffer)))))
      (dolist (pkg packages-list)
        (unless (package-installed-p pkg)
          (package-install pkg))))))

;; ============== Look and feel ================ ;;

;; Color theme
(load-theme 'odersky t)

;; Cool mode line
(sml/setup)
(set-face-attribute 'mode-line nil
                    :inverse-video nil
                    :box nil
                    :overline nil
                    :underline nil)

(make-face 'mode-line-position-face)
(set-face-attribute 'mode-line-position-face nil
                    :inherit 'mode-line-face
                    :height 130)

;; =========== End of configuration ============ ;;
(provide 'config)
;;; config.el ends here
