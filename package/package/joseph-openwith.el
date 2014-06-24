;;  openwith ,外部程序

;;直接用正常的方式打开相应的文件,openwith会自动做处理
;;`C-xC-f'即可
(when (eq system-type 'windows-nt)
  (require'w32-shell-execute)
  )
(require 'openwith)
(openwith-mode t)
(when (eq system-type 'gnu/linux)
  (setq openwith-associations
        ;; acroread to evince
        '(("\\.pdf$" "evince" (file)) ("\\.mp3$" "mplayer" (file) )
          ("\\.mov\\|\\.RM$\\|\\.RMVB$\\|\\.avi$\\|\\.AVI$\\|\\.flv$\\|\\.mp4\\|\\.mkv$\\|\\.rmvb$" "mplayer" (file) )
;;          ("\\.jpe?g$\\|\\.png$\\|\\.bmp\\|\\.gif$" "gpicview" (file))
          ("\\.CHM$\\|\\.chm$" "chmsee"  (file) )
          )
        )
  )
(when (eq system-type 'windows-nt)
  ;;windows 上使用w32-shell-execute 调用系统的相应程序打开
  (setq openwith-associations
        '(("\\.pdf$" "open" (file)) ("\\.mp3$" "open" (file) )
          ("\\.mov\\|\\.RM$\\|\\.RMVB$\\|\\.avi$\\|\\.AVI$\\|\\.flv$\\|\\.mp4\\|\\.mkv$\\|\\.rmvb$" "open" (file) )
          ("\\.jpe?g$\\|\\.png$\\|\\.bmp\\|\\.gif$" "open" (file))
          ("\\.CHM$\\|\\.chm$" "open"  (file) )
          ("\\.html$|\\.htm$" "open" (file))
          )
        )
  )



;; 使用外部 文件管理器 打开选中文件所在文件夹
(when (eq system-type 'windows-nt)
  ;;on windows
  ;;  C-RET  用系统默认程序打开选中文件
  ;; M-RET  open Windows Explorer
  ;; ^ 我改成了u ,可以列出根盘符
  ;;
  (require 'w32-browser)
  ;; (define-key diredp-w32-drives-mode-map "n" 'next-line)
  ;; (define-key diredp-w32-drives-mode-map "p" 'previous-line)

  ;;C-M-<RET> 用资源管理器打开当前文件所处目录
  (defun explorer-open()
"用windows 上的explorer.exe打开此文件夹."
    (interactive)
    (if (equal major-mode 'dired-mode)
        (w32explore (expand-file-name (dired-get-filename)))
      (w32explore (expand-file-name (buffer-file-name)))
       )
    )
  (eval-after-load 'dired
    '(define-key dired-mode-map (quote [C-M-return]) 'explorer-open))
  (global-set-key (quote [C-M-return]) 'explorer-open)
  (define-key global-map [C-return] 'w32-shell-execute-verb)
;;  (lambda () (interactive ) (w32explore (expand-file-name default-directory)))
  )

;; linux `C-M-RET' 用pcmanfm文件管理器打开当前目录
(when (eq system-type 'gnu/linux)
  (defun open-directory-with-pcmanfm()
    (interactive)
    (start-process "pcmanfm"  nil "pcmanfm" (expand-file-name  default-directory)))
  (eval-after-load 'dired
    '(define-key dired-mode-map (quote [C-M-return]) 'open-directory-with-pcmanfm))
  (global-set-key (quote [C-M-return]) (quote open-directory-with-pcmanfm))
    )

(provide 'joseph-openwith)
