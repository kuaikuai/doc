(defconst my-lisps-path     (concat  "~/package" nil) "emacs plugin path")
(if (eq system-type 'windows-nt)
    (progn
      (set-frame-font "-outline-Consolas-normal-normal-normal-mono-15-*-*-*-c-*-iso8859-1")
      (add-to-list 'default-frame-alist '(font . "-outline-Consolas-normal-normal-normal-mono-15-*-*-*-c-*-iso8859-1"))
      )
  (progn
    ;;(set-default-font "Inconsolata-11")
    ))

;;(require 'cl)

;; solve problem "Variable binding depth exceeds max-specpdl-size", 
;; default value is 1080 
(setq max-specpdl-size 34000)
(setq max-lisp-eval-depth 20000)

;; 关闭菜单栏、工具条、滚动条
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;使用鼠标选择后，自动进入kill-ring
(setq mouse-drag-copy-region t) 
(setq x-select-enable-clipboard t)
;;显示括号匹配
(show-paren-mode t)
;;括号匹配时显示另外一边的括号，而不是跳到另一个括号
(setq show-paren-style 'parentheses)
;;显示所在行号和列号
(column-number-mode t)
;; 光标显示为一竖线
(setq-default cursor-type 'bar)
;; 不要问 yes-or-no,只问 y-or-n
(fset 'yes-or-no-p 'y-or-n-p)
;; 关闭工具栏
(tool-bar-mode -1)
;; 平滑滚动
(setq scroll-step           1
      scroll-conservatively 10000)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; 正在编辑的文件被其他程序修改时，自动更新缓存区
(global-auto-revert-mode 1)
(setq view-read-only t)
(setq make-backup-files nil)
;;(setq default-frame-alist'((height . 30) (width .40) (menu-bar-lines . 20) (tool-bar-lines . 0)))

(desktop-save-mode 1)
;;禁用菜单栏，F10 开启关闭菜单
;;(menu-bar-mode nil)
;;用空格代替TAB
(setq-default indent-tabs-mode nil)
;;写文件时的默认编码
(setq buffer-file-coding-system 'utf-8)
;;读文件时的编码
(prefer-coding-system 'utf-8)
;; windows文件名编码要改回 gbk
(if (eq system-type 'windows-nt)
    (setq file-name-coding-system 'chinese-gbk))
(when (eq window-system 'x) ; emacs和其它程序互相拷贝
  (setq x-select-enable-clipboard t))
;; 设置emacs的标题
(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (file-truename (buffer-file-name))
                (buffer-name))))

;; iimage mode 显示内置图片
;; 使用iimage-mode看org文档中的图片
(autoload 'iimage-mode "iimage" "Support Inline image minor mode." t)
(autoload 'turn-on-iimage-mode "iimage" "Turn on Inline image minor mode." t)

;; 终端中可以paste字符串
(add-hook 'term-mode-hook (lambda ()
                            (define-key term-raw-map (kbd "C-y") 'term-paste)))

;;(add-hook 'term-mode-hook 'term-line-mode)

;; 基本功能的键盘绑定----------------------------
;; backspace太远 从effective emacs学的招
(global-set-key "\C-w" 'backward-kill-word)
;;既又原来c-k又有c-w的功能
(global-set-key "\C-k" 'yxf-kill-region-or-line)
(defalias 'qrr 'query-replace-regexp)

;;C-.记录当前位置，稍后可用C-,跳回来
(global-set-key [(control ?\.)] 'point-to-register)
(global-set-key [(control ?\,)] 'jump-to-register)
;;不使用默认的list-buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c r") 'replace-string)
(global-set-key (kbd "C-c p") 'delete-indentation)
(global-set-key (kbd "C-c q") 'query-replace)
;; 交换了ctrl 与ATL 键盘后， C-M-\键盘不起作用了
(global-set-key [(control ?\\)] 'indent-region)
;(global-set-key (kbd "<f4>") 'shell-command)
(global-set-key [f1] 'compile)
(global-set-key (kbd "C-SPC") 'nil)
(global-set-key [(control tab)] 'other-frame)

;; find . -name "*.[ch] | xargs  etags -
;; atl + .  查找一个TAG
;; atl + ,  跳到查找之前的位置
(global-set-key [(meta ?\,)] 'pop-tag-mark)

(define-prefix-command 'ctl-z-map)
(global-set-key (kbd "C-z") 'ctl-z-map)
;; 设置标记 默认C-SPC 被输入法截获，无法使用
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

;;;;启动Emacs Server
(setq server-mode t)
(server-start)
;; 扩展模块---------------------------------------
(add-to-list 'load-path "~/package")
(add-to-list 'load-path "~/package/color-theme-6.6.0")
(add-to-list 'load-path "~/package/dark-mode")

(add-to-list 'load-path "~/package/smex")
;; 快速输入emacs 命令
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                  ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)



(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;; 矩形块操作
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

;; windows 使用cygwin
(if (eq system-type 'windows-nt)
    (progn
      (setenv "PATH" (concat "E:/cygwin/bin;" (getenv "PATH")))
      (setq exec-path (cons "E:/cygwin/bin/" exec-path))
      (require 'cygwin-mount)
      (cygwin-mount-activate)
      (add-hook 'comint-output-filter-functions
                'shell-strip-ctrl-m nil t)
      (add-hook 'comint-output-filter-functions
                'comint-watch-for-password-prompt nil t)
      (setq explicit-shell-file-name "E:/cygwin/bin/bash.exe")
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


(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
;; C-return 使用 c的模板
;; 详见代码
(require 'tempo-c-cpp)

(load "~/package/haskell-mode-2.8.0/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(require 'tiny)
;;(yxf-switch-num-sign)
;;快速切换到*scratch*
(global-set-key (kbd "C-z c") 'ywb-create/switch-scratch)
(global-set-key (kbd "C-z e") 'yxf-create/switch-shell)
;;格式化整个缓存区
(global-set-key (kbd "C-z f" ) 'yxf-format-full)
;;history stack,跳来跳去
(global-set-key (kbd "<f7>") 'yxf-point-stack-push)
(global-set-key (kbd "<f8>") 'yxf-point-stack-pop)
(require 'copy)
(global-set-key (kbd "C-z w")         (quote copy-word))
;;(global-set-key (kbd "C-z l")         (quote copy-line))
;;(global-set-key (kbd "C-z d")         (quote copy-paragraph))
(global-set-key (kbd "C-z s")         (quote thing-copy-parenthesis-to-mark))
;;M-C-a，在gnome有别的键绑定了
;;跳到函数开头
(global-set-key (kbd "C-z a")         (quote beginning-of-defun))
;;跳到函数结尾
(global-set-key (kbd "C-z e")         (quote end-of-defun))

(global-set-key (kbd "C-x C-s") 
  (lambda()
    (interactive)
   (set-buffer-file-coding-system 'unix 't)

    (save-buffer)))
;;用于w32系统，全屏; M-x w32-fullscreen
;;(if (eq system-type 'windows-nt)
;;    (require 'darkroom-mode))

(require 'color-theme)
(color-theme-initialize)
(color-theme-gnome2)

;; 将color-theme放在multi-term前，
;; 否则color-theme的颜色设置回混乱
;; 可以运行多个终端，呵呵
;;(defun ad-advised-definition-p (def) t)
;;(require 'multi-term)
;;(setq multi-term-program "/bin/bash")
;;(setq multi-term-buffer-name "term")

;; 在dired下使用应用打开文件,具体joseph-openwith
(require 'joseph-openwith)

;; 调用gnupg加密
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
(global-set-key [(meta down)] 'other-frame)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)

;;用于加亮变量, cedet中也该功能，不过较慢
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
;(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)

(require 'xcscope)

(require 'ido)
(ido-mode t)

;; most powerful !!!
;; 说明文档见http://tuhdo.github.io/helm-intro.html
(add-to-list 'load-path "~/package/helm")
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "C-x b") 'helm-mini)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

;; org-mode ----------------------------
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock)
(add-hook 'org-mode-hook
          (lambda () (setq truncate-lines nil)))
(add-hook 'org-mode-hook
          (lambda ()
            (define-key org-mode-map "\C-z\C-t" 'org-insert-todo-heading)
                            ;; keybinding for editing source code blocks
            (local-set-key (kbd "C-c s e")
                           'org-edit-src-code)
            ;; keybinding for inserting code blocks
            (local-set-key (kbd "C-c s i")
                           'org-insert-src-block)
            ;; org mode 中代码着色
            (setq org-src-fontify-natively t)
            (define-key org-mode-map "\C-z\C-e" 'org-insert-todo-subheading)))


(setq org-default-notes-file "~/.notes")
(define-key global-map [f12] 'org-remember)

;;C-c a 进入日程表
(define-key global-map "\C-ca" 'org-agenda)
;;给已完成事项打上时间戳。可选 note，附加注释
(setq org-log-done 'time)
;;防止下划线在export时变成下标
(setq org-export-with-sub-superscripts nil)
(autoload 'org-diary "org" "Diary entries from Org mode" )
(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DOING(i)" "|" "DONE(d)")
        ;;(sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
        (sequence "|" "CANCELED(c)")))

(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))

(setq org-log-done t) ;; 变到 done 状态的时候，记录一下时间
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
;;自动换行
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
;;-------------AUTO COMPLETE----------------------------
(add-to-list 'load-path "~/package/fuzzy-el")
(add-to-list 'load-path "~/package/popup-el")
(add-to-list 'load-path "~/package/auto-complete")
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

(setq compile-command "make ")

;;----------------CEDET-----------------------
;;使用emacs自带
(require 'cedet)
;; Enable EDE (Project Management) features
(global-ede-mode 1)
;;现在使用auto-complete 补全
;(global-set-key [(meta ?/)] 'hippie-expand)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/org/body.org" "~/org/booklist.org" "~/org/booknotes.org" "~/org/bug.org" "~/org/ceph.org" "~/org/dream.org" "~/org/emacs.org" "~/org/health.org" "~/org/index.org" "~/org/kernel.org" "~/org/kidfs.org" "~/org/link.org" "~/org/mrouter.org" "~/org/mygtd.org" "~/org/net.org" "~/org/notes.org" "~/org/paxos.org" "~/org/perl.org" "~/org/think.org" "~/org/todo.org" "~/org/work.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
