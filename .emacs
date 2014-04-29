(defconst my-lisps-path     (concat  "~/package" nil) "emacs plugin path")
(if (eq system-type 'windows-nt)
    (progn
      (set-frame-font "-outline-Consolas-normal-normal-normal-mono-15-*-*-*-c-*-iso8859-1")
      (add-to-list 'default-frame-alist '(font . "-outline-Consolas-normal-normal-normal-mono-15-*-*-*-c-*-iso8859-1"))
      )
  (progn
    ;;(set-default-font "Inconsolata-11")
    ))
;; server mode
(require 'server)
(when (and (>= emacs-major-version 23)
           (equal window-system 'w32))
  (defun server-ensure-safe-dir (dir) "Noop" t)) ; Suppress error "directory
                                        ; ~/.emacs.d/server is unsafe"
                                        ; on windows.
;;(server-start)
;;(require 'cl)

;; solve problem "Variable binding depth exceeds max-specpdl-size", 
;; default value is 1080 
(setq max-specpdl-size 34000)
(setq max-lisp-eval-depth 20000)

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))


(setq mouse-drag-copy-region t) 
(setq x-select-enable-clipboard t)

(show-paren-mode t)

(setq show-paren-style 'parentheses)

(column-number-mode t)

(setq-default cursor-type 'bar)

(fset 'yes-or-no-p 'y-or-n-p)

(tool-bar-mode -1)

(setq scroll-step           1
      scroll-conservatively 10000)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time


(global-auto-revert-mode 1)
(setq view-read-only t)
(setq make-backup-files nil)
;;(setq default-frame-alist'((height . 30) (width .40) (menu-bar-lines . 20) (tool-bar-lines . 0)))

(desktop-save-mode 1)
;;(menu-bar-mode nil)

(setq-default indent-tabs-mode nil)

(setq buffer-file-coding-system 'utf-8)

(prefer-coding-system 'utf-8)

(if (eq system-type 'windows-nt)
    (setq file-name-coding-system 'chinese-gbk))
(when (eq window-system 'x)
  (setq x-select-enable-clipboard t))

(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (file-truename (buffer-file-name))
                (buffer-name))))

(autoload 'iimage-mode "iimage" "Support Inline image minor mode." t)
(autoload 'turn-on-iimage-mode "iimage" "Turn on Inline image minor mode." t)


(add-hook 'term-mode-hook (lambda ()
                            (define-key term-raw-map (kbd "C-y") 'term-paste)))

;;(add-hook 'term-mode-hook 'term-line-mode)


(global-set-key "\C-w" 'backward-kill-word)

(global-set-key "\C-k" 'yxf-kill-region-or-line)
(defalias 'qrr 'query-replace-regexp)

(global-set-key [(control ?\.)] 'point-to-register)
(global-set-key [(control ?\,)] 'jump-to-register)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c r") 'replace-string)
(global-set-key (kbd "C-c p") 'delete-indentation)
(global-set-key (kbd "C-c q") 'query-replace)

(global-set-key [(control ?\\)] 'indent-region)
;(global-set-key (kbd "<f4>") 'shell-command)
(global-set-key (kbd "C-SPC") 'nil)
(global-set-key [(control tab)] 'other-frame)

;; find . -name "*.[ch] | xargs  etags -
;; find . -name "*.[ch]" -o -name "*.cpp" -o -name "*.hpp" | xargs etags -a
;; M-x visit-tags-table
;; M-. find a tag
;; C-u M-. find next tag
;; M-, back
(global-set-key [(meta ?\,)] 'pop-tag-mark)

(define-prefix-command 'ctl-z-map)
(global-set-key (kbd "C-z") 'ctl-z-map)

(global-set-key (kbd "C-z m") 'set-mark-command)

(autoload 'todo-mode "todo-mode"
  "Major mode for editing TODO lists." t)
(autoload 'todo-show "todo-mode"
  "Show TODO items." t)
(autoload 'todo-insert-item "todo-mode"
  "Add TODO item." t)

(defun my-toggle-fullscreen ()
  (interactive)
  (case system-type
    ((gnu/linux)  ())
    ((mac)        ())
    (otherwise    (w32-fullscreen))))

(global-set-key [f12] 'my-toggle-fullscreen)

(require 'tempo)
(setq tempo-interactive t)


(setq server-mode t)
(server-start)

(add-to-list 'load-path "~/package")
(add-to-list 'load-path "~/package/color-theme-6.6.0")
(add-to-list 'load-path "~/package/dark-mode")

;; auto detect unicode
(require 'unicad)

(require 'rect-mark)
(define-key ctl-x-map "r\C-m" 'rm-set-mark)
(define-key ctl-x-map [?r ?\C-\ ] 'rm-set-mark)
(define-key ctl-x-map "r\C-x" 'rm-exchange-point-and-mark)
(define-key ctl-x-map "r\C-w" 'rm-kill-region)
(define-key ctl-x-map "r\M-w" 'rm-kill-ring-save)
(define-key global-map [S-down-mouse-1] 'rm-mouse-drag-region)
(autoload 'rm-set-mark "rect-mark"     
   "Set mark for rectangle." t)
(autoload 'rm-exchange-point-and-mark "rect-mark"  
   "Exchange point and mark for rectangle." t)
(autoload 'rm-kill-region "rect-mark"  
   "Kill a rectangular region and save it in the kill ring." t)
(autoload 'rm-kill-ring-save "rect-mark"  
   "Copy a rectangular region to the kill ring." t)
(autoload 'rm-mouse-drag-region "rect-mark"  
   "Drag out a rectangular region with the mouse." t)


(if (eq system-type 'windows-nt)
    (progn
      (setenv "PATH" (concat "D:/cygwin/bin;" (getenv "PATH")))
      (setq exec-path (cons "D:/cygwin/bin/" exec-path))
      (require 'cygwin-mount)
      (cygwin-mount-activate)
      (add-hook 'comint-output-filter-functions
                'shell-strip-ctrl-m nil t)
      (add-hook 'comint-output-filter-functions
                'comint-watch-for-password-prompt nil t)
      (setq explicit-shell-file-name "bash.exe")
      ;; For subprocesses invoked via the shell
      ;; (e.g., "shell -c command")
      (setq shell-file-name explicit-shell-file-name)
      ))
;; Prevent issues with the Windows null device (NUL)
;; when using cygwin find with rgrep.
(if (equal system-type 'windows-nt)
    (progn
      (defadvice grep-compute-defaults (around grep-compute-defaults-advice-null-device)
        "Use cygwin's /dev/null as the null-device."
        (let ((null-device "/dev/null"))
          ad-do-it))
      (ad-activate 'grep-compute-defaults)))

(require 'tramp)
(setq tramp-default-method "ssh")

(if (eq system-type 'windows-nt)
  (eval-after-load "tramp"
    '(progn
       (add-to-list 'tramp-methods
                    (mapcar
                     (lambda (x)
                       (cond
                        ((equal x "sshx") "cygssh")
                        ((eq (car x) 'tramp-login-program) (list 'tramp-login-program "fakecygpty ssh"))
                        (t x)))
                     (assoc "sshx" tramp-methods)))
       (setq tramp-default-method "cygssh"))))

(setq password-cache-expiry nil)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

(require 'tempo-c-cpp)

(load "~/package/haskell-mode-2.8.0/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)


(eval-when-compile (require 'lusty-explorer))
(require 'lusty-explorer)
;;(eval-when-compile (require 'anything-config))
(require 'tiny)
;;(yxf-switch-num-sign)
(global-set-key (kbd "C-z c") 'ywb-create/switch-scratch)
(global-set-key (kbd "C-z e") 'yxf-create/switch-shell)

(global-set-key (kbd "C-z f" ) 'yxf-format-full)

(global-set-key (kbd "<f7>") 'yxf-point-stack-push)
(global-set-key (kbd "<f8>") 'yxf-point-stack-pop)
(require 'copy)
(global-set-key (kbd "C-z w")         (quote copy-word))
;;(global-set-key (kbd "C-z l")         (quote copy-line))
;;(global-set-key (kbd "C-z d")         (quote copy-paragraph))
(global-set-key (kbd "C-z s")         (quote thing-copy-parenthesis-to-mark))

(global-set-key (kbd "C-z a")         (quote beginning-of-defun))

(global-set-key (kbd "C-z e")         (quote end-of-defun))

(global-set-key (kbd "C-x C-s") 
  (lambda()
    (interactive)
   (set-buffer-file-coding-system 'unix 't)

    (save-buffer)))
;; M-x w32-fullscreen
(if (eq system-type 'windows-nt)
    (require 'darkroom-mode))

(require 'smart-compile)
(global-set-key (kbd "<f1>") 'smart-compile)
(require 'color-theme)
(color-theme-initialize)
(color-theme-gnome2)



(require 'multi-term)
(setq multi-term-program "/bin/bash")
(setq multi-term-buffer-name "term")


(require 'joseph-openwith)

(require 'epa-file)
(epa-file-enable)
;; auto-save
(setq epa-file-inhibit-auto-save nil)

(require 'tabbar)
(tabbar-mode)
;;(global-set-key  'tabbar-backward-group)
;;(global-set-key [(control f10)] 'tabbar-local-mode)
(global-set-key [(control up)] 'tabbar-forward-group)
(global-set-key [(control down)] 'tabbar-backward-group)
(global-set-key [(control right)] 'tabbar-forward)
(global-set-key [(control left)] 'tabbar-backward)

(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)


(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
;(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)

(require 'xcscope)

;; c-x c-f ido-find-file
(require 'ido)
(ido-mode t)

;; redo/undo key: c-c <left>/<right>
(when (fboundp 'winner-mode)
  (winner-mode 1))

(eval-after-load 'anything
  '(progn
     (setq anything-enable-digit-shortcuts t)
     (global-set-key (kbd "C-z a") 'anything)))

(eval-after-load 'anything-config
  '(add-to-list 'anything-sources anything-c-source-file-cache))
(require 'anything)
;;(require 'anything-config)
(global-set-key [f5] 'anything)

;; This is how you would do it by hand
(defun view-pdf ()
  "Use evince to view PDFs."
  (interactive)
  (progn
    (read-only-mode t)
    (start-process "pdf" nil
                   "evince" (buffer-file-name))
    (kill-buffer (current-buffer))))

;;;_ , Word documents

(defun no-word ()
  "Run antiword on the entire buffer."
  (shell-command-on-region (point-min) (point-max) "antiword - " t t))
;;(autoload 'no-word "no-word" "word to txt")
;;(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word))


;; ------------------- org-mode ----------------------------
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock)
(add-hook 'org-mode-hook
          (lambda () (setq truncate-lines nil)))
(add-hook 'org-mode-hook
          (lambda ()
            (define-key org-mode-map "\C-z\C-t" 'org-insert-todo-heading)
            (define-key org-mode-map "\C-z\C-e" 'org-insert-todo-subheading)))

(setq org-default-notes-file "~/.notes")
(define-key global-map [f12] 'org-remember)


(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done 'time)

(setq org-export-with-sub-superscripts nil)
(autoload 'org-diary "org" "Diary entries from Org mode" )
(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DOING(i)" "|" "DONE(d)")
        ;;(sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
        (sequence "|" "CANCELED(c)")))

(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))

(setq org-log-done t)
(setq org-log-done 'time)
                                        ;(setq org-log-done 'note)

(org-agenda-to-appt)

(setq org-tag-alist
      '(("tips" . ?t) ("question" . ?u) ("perl" . ?p) ("thought" . ?h) ("protocol" . ?r)))

(setq org-publish-project-alist
      '(("note-org"
         :base-directory "~/org"
         :publishing-directory "~/org/publish"
         :base-extension "org"
         :recursive t
         :publishing-function org-publish-org-to-html
         :auto-index nil
         :index-filename "index.org"
         :index-title "index"
         :link-home "index.html"
         :section-numbers nil
         :style "<link rel=\"stylesheet\"
                href=\"./style/emacs.css\"
                type=\"text/css\"/>")
        ("note-static"
         :base-directory "~/org"
         :publishing-directory "~/org/publish"
         :recursive t
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|swf\\|zip\\|gz\\|txt\\|el"
         :publishing-function org-publish-attachment)
        ("note"
         :components ("note-org" "note-static")
         :author "3wdays@gmail.com")))

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
;;-------------AUTO COMPLETE----------------------------
(add-to-list 'load-path "~/package/auto-complete-1.3.1")
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(ac-config-default)
(setq ac-auto-start 2)
(setq ac-auto-show-menu nil)
(setq ac-use-fuzzy t)
(setq ac-stop-flymake-on-completing t)
(setq ac-dwim nil) ; To get pop-ups with docs even if a word is uniquely completed
;; (setq ac-ignores '("." "=" "@" "[" "]" "(" ")"))
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")

(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)

;; Use Emacs' built-in TAB completion hooks to trigger AC (Emacs >= 23.2)
(setq tab-always-indent 'complete)  ;; use 'complete when auto-complete is disabled
(add-to-list 'completion-styles 'initials t)
;; hook AC into completion-at-point
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)

(set-default 'ac-sources
             '(ac-source-yasnippet
               ac-source-abbrev
               ac-source-dictionary
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers
               ac-source-words-in-all-buffer))

(dolist (mode '(magit-log-edit-mode log-edit-mode org-mode text-mode haml-mode
                sass-mode yaml-mode csv-mode espresso-mode haskell-mode
                html-mode nxml-mode sh-mode smarty-mode clojure-mode
                lisp-mode textile-mode markdown-mode tuareg-mode
                sass-mode scss-mode ruby-mode
                js2-mode css-mode rhtml-mode
                c-mode
                ))
  (add-to-list 'ac-modes mode))

;; Exclude very large buffers from dabbrev
(defun sanityinc/dabbrev-friend-buffer (other-buffer)
  (< (buffer-size other-buffer) (* 1 1024 1024)))

(setq dabbrev-friend-buffer-function 'sanityinc/dabbrev-friend-buffer)
;;----------------END OF AUTO COMPLETE---------------------------
(add-to-list 'load-path "~/package/company-mode")
;;(autoload 'company-mode "company" nil t)
;;(setq company-idle-delay t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'c-mode-hook
          '(lambda ()
             (c-set-style "linux")
	     (setq c-basic-offset 4)))
(add-hook 'c++-mode-hook
          '(lambda ()
             (c-set-style "linux")
	     (setq c-basic-offset 4)))

(setq compile-command "make")

;;----------------CEDET-----------------------

(require 'cedet)
;; Enable EDE (Project Management) features
(global-ede-mode 1)

;(global-set-key [(meta ?/)] 'hippie-expand)


;; 
;;(add-to-list 'load-path "~/package/auctex")
;;(load "auctex.el" nil t t)
;;(setq TeX-auto-save t)
;;(setq TeX-parse-self t)
;;(setq-default TeX-master nil)
;;(load "preview-latex.el" nil t t)

;;(setq TeX-output-view-style (quote (("^pdf$" "." "evince %o %(outpage)"))))
;;(setq TeX-output-view-style (quote (("^pdf$" "." "AcroRd32.exe %o %(outpage)"))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/org/body.org" "~/org/booklist.org" "~/org/booknotes.org" "~/org/bug.org" "~/org/capture.org" "~/org/ceph.org" "~/org/dream.org" "~/org/emacs.org" "~/org/faq.org" "~/org/health.org" "~/org/index.org" "~/org/kernel.org" "~/org/kernel2.org" "~/org/kidfs.org" "~/org/link.org" "~/org/linux_command.org" "~/org/lvs_source.org" "~/org/memo.org" "~/org/mygtd.org" "~/org/notes.org" "~/org/org-mode.org" "~/org/paxos.org" "~/org/perl.org" "~/org/python.org" "~/org/record.org" "~/org/record_syncookie.org" "~/org/security.org" "~/org/sourcecode.org" "~/org/think.org" "~/org/todo.org" "~/org/tools.org" "~/org/work.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
