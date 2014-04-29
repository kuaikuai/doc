
;;(set-frame-font "-unknown-VL Gothic-normal-normal-normal-*-15-*-*-*-*-0-iso10646-1")
;; 开启新frame时的字体
;;(add-to-list 'default-frame-alist
;;             '(font . "-unknown-VL Gothic-normal-normal-normal-*-15-*-*-*-*-0-iso10646-1")))
(if (eq system-type 'windows-nt)
(defun ssh (hostname &optional flags)
  "Start an SSH session in a shell window."
  (interactive "MSSH to host: ")
  (let ((buf (concat "*SSH:" hostname "*")))
    (if (and (get-buffer buf) (get-buffer-process buf))
        (switch-to-buffer-other-window buf)
      (async-shell-command (concat "fakecygpty ssh " flags (when flags " ") hostname) buf))))
)
(if (eq system-type 'windows-nt)  
(defun sshx (hostname)
  "Start an SSH session with X11 forwarding in a shell window."
  (interactive "MSSH to host (X11): ")
  (ssh hostname "-X")))

;; =================== etags =====================
(defvar tags-cmd "etags -R ./* 2>/dev/null")

(defun regen-tags ()
  "Regenerate the tags file for the current working directory"
  (interactive)
  (let ((tag-file (concat default-directory "TAGS")))
    (shell-command tags-cmd)
    (visit-tags-table tag-file)))
;; =================== end etags =====================

(defun yxf-scp ()
  ""
  (interactive)
  (call-process "d:/tools/pscp.exe" nil nil nil "-pw" "root" "-scp" "d:/code/mon/*.py"  "root@10.0.64.19:/root/mon")
  (call-process "d:/tools/pscp.exe" nil nil nil "-pw" "root" "-scp" "d:/code/mon/*.py"  "root@10.0.64.18:/root/mon")
  (call-process "d:/tools/pscp.exe" nil nil nil "-pw" "hisense~!@#hitv" "-scp" "d:/code/mon/*.*"  "root@172.16.132.234:/root/mon")
  (call-process "d:/tools/pscp.exe" nil nil nil "-pw" "hisense~!@#hitv" "-scp" "d:/code/mon/filters/*.*"  "root@172.16.132.234:/root/mon/filters")
  (call-process "d:/tools/pscp.exe" nil nil nil "-pw" "hisense~!@#hitv" "-scp" "d:/code/mon/views/*.*"  "root@172.16.132.234:/root/mon/views")
  (call-process "d:/tools/pscp.exe" nil nil nil "-pw" "root" "-scp" "d:/code/mon/*.py"  "root@10.0.64.18:/root/mon"))


(defvar point-stack nil)

(defun yxf-point-stack-push ()
  "Push current location and buffer info onto stack."
  (interactive)
  (message "Location marked.")
  (setq point-stack
        (cons (list (current-buffer) (point)) point-stack)))

(defun yxf-point-stack-pop ()
  "Pop a location off the stack and move to buffer"
  (interactive)
  (if (null point-stack)
      (message "Stack is empty.")
    (switch-to-buffer (caar point-stack))
    (goto-char (cadar point-stack))
    (setq point-stack (cdr point-stack))))

;; 格式化整个文件
;; 之前我总是先c-x h 选中整个文件，然后ctrl-alt-\，很笨拙
(defun yxf-format-full ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil))

;;使用pdftotext,看pdf
;;对于文字为主的pdf,
;;中间有空格的文件，需要在空格前加\
(defun yxf-pdf (name)
  "Run pdftotext on the entire buffer."
  (interactive "sInput PDF File name:")
  (shell-command
   (concat "pdftotext " name " -")  "*yxf-pdf*"
   ))

;; 我经常用 *scratch*，临时放些文本、写一些函数之类。
;; 快速切换到*scratch*
(defun ywb-create/switch-scratch ()
  (interactive)
  (let ((buf (get-buffer "*scratch*")))
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (when (null buf)
      (lisp-interaction-mode))))

(defun yxf-create/switch-shell ()
  (interactive)
  (let ((buf (get-buffer "*shell*")))
    (switch-to-buffer (get-buffer-create "*shell*"))
    (when (null buf)
      (lisp-interaction-mode))))


;;; 自动调用相应的程序
;;; 不支持文件名中有空格的情况
(defun define-trivial-mode(mode-prefix file-regexp &optional command)
  (or command (setq command mode-prefix))
  (let ((mode-command (intern (concat mode-prefix "-mode"))))
    (fset mode-command
          `(lambda ()
             (interactive)
             (progn
               (message (buffer-file-name))
               (start-process-shell-command ,mode-prefix nil ,command (concat "\"" (buffer-file-name) "\""))
               (kill-buffer (current-buffer)))))
    (add-to-list 'auto-mode-alist (cons file-regexp mode-command))))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; 交换两个窗口，从网上搞的
(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((not (= (count-windows) 2))
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1)))))

(defun yxf-kill-region-or-line(&optional arg)
  "this function is a wrapper of (kill-line).
   When called interactively with no active region, this function
  will call (kill-line) ,else kill the region."
  (interactive "P")
  (if mark-active
      (if (= (region-beginning) (region-end) ) (kill-line arg)
        (kill-region (region-beginning) (region-end) )
        )
    (kill-line arg)
    )
  )

;; 将\r\n形式换行的文件，转换为\n的unix格式
(defun yxf-unix-coding()
  (interactive)
  (set-buffer-file-coding-system 'unix 't))

;;(save-buffer))

(defun yxf-zap-to-string (arg str)
  "Same as `zap-to-char' except that it zaps to the given string
instead of a char."
  (interactive "p\nsZap to string: ")
  (kill-region (point) (progn
                         (search-forward str nil nil arg)
                         (point))))

(defun yxf-zap-backward-to-string (&optional arg str)
  "Zap to string back"
  (interactive "p\nsZap backward to string: ")
 (th-zap-to-string (- arg) str))


(provide 'tiny)
