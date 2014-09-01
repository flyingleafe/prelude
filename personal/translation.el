;;; translation.el --- Make keybindings available in Cyrillic layout
;;; Commentary:
;; USAGE:
;; Put in your .emacs:
;;
;; (translate-keystrokes-ru->en)
;; (add-hook 'text-mode-hook
;;           (lambda () (literal-insert-mode 1)))
;;
;; Only buffers with literal-insert-mode active will be sensitive to the
;; environment language. Prefixed keybindings will still be usable.

;;; Code:
(defun translate-keystrokes-ru->en ()
  "Make emacs output english characters, regardless whether
the OS keyboard is English or Russian."
  (flet ((make-key-stroke (prefix char)
           (eval `(kbd ,(if (and (string-match "^C-" prefix)
                                 (string-match "[A-Z]" (string char)))
                            (concat "S-" prefix (string (downcase char)))
                            (concat prefix (string char)))))))
    (let ((case-fold-search nil)
          (keys-pairs (mapcar* 'cons
                               "йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖ\ЭЯЧСМИТЬБЮ№"
                               "qwertyuiop[]asdfghjkl;'zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>#"))
          (prefixes '("s-"   "M-"    "M-s-"  "H-"
                      "C-"   "C-s-"  "C-M-"  "C-M-s-")))
      (mapc (lambda (prefix)
              (mapc (lambda (pair)
                      (define-key key-translation-map
                          (make-key-stroke prefix (car pair))
                        (make-key-stroke prefix (cdr pair))))
                    keys-pairs))
            prefixes))))

(translate-keystrokes-ru->en)

(defun literal-insert ()
  (interactive)
  (insert-char last-input-event 1))

(define-minor-mode literal-insert-mode
    "Make emacs output characters corresponging to the OS keyboard,
 ignoring the key-translation-map"
  :keymap (let ((new-map (make-sparse-keymap))
                (english-chars "qwertyuiop[]asdfghjkl;'zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>#"))
            (mapc (lambda (char)
                    (define-key new-map (string char)
                      'literal-insert))
                  english-chars)
            new-map))
;;; translation.el ends here
