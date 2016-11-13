;;
;; init.el
;;
;;======================================================================
;; Load Path
;;======================================================================
(setq load-path (cons "~/.emacs.d/elisp" load-path))

;; Language.
(set-language-environment 'Japanese)

;; Coding system.
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;*scratch*を初期画面にする
(setq inhibit-startup-screen t)

;;起動時のサイズ, 表示位置を指定
(setq initial-frame-alist
      (append (list
               '(top . 0)
               '(left . 0)
               '(width . 140)
               '(height . 45)
               )
              initial-frame-alist))

;;======================================================================
;; Look and feel
;;======================================================================
;; 背景
(if window-system
    (progn   (set-frame-parameter nil 'alpha 100)
;;             (set-background-color "#2F2F30")
             (set-background-color "#000000")
             (set-foreground-color "white")
             )
  )

;; monokai
;;(load-theme 'monokai t)

;; Package Manegement
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; Cygwin用の設定
(setq cygwin-mount-cygwin-bin-directory "C:/cygwin64/bin")
(require 'setup-cygwin)
(require 'cygwin-mount)

;; visible-bell
(setq visible-bell t)
(which-func-mode t)

;; mark 領域に色付け
(setq transient-mark-mode t)

;; window分割時に画面外に出る文章を折り返す
(setq truncate-partial-width-windows t)

;; Frame Title
(setq frame-title-format "Emacs: %b")

;; 編集行のハイライト
(global-hl-line-mode)

;; ツールバーとスクロールバーを消す
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; color
(global-font-lock-mode t)

;;; 行番号・桁番号を表示
(line-number-mode 1)
(column-number-mode 1)

;;; モードラインに時刻を表示
;;(display-time)
;;(setq display-time-format "%Y-%m-%d (%a) %H:%M")

;; 以下の書式に従ってモードラインに日付・時刻を表示する
(setq display-time-string-forms
      '((format "%s/%s/%s(%s) %s:%s" year month day dayname 24-hours minutes)
        load
        (if mail " Mail" "")))
;; 時刻表示の左隣に日付を追加。
(setq display-time-kawakami-form t)
;; 24時間制
(setq display-time-24hr-format t)

;; 時間を表示
(display-time)

;;; 履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;;; ファイル内のカーソル位置を記憶する
(save-place-mode 1)

;;; yes/no を y/n に変更
(defalias 'yes-or-no-p 'y-or-n-p)

;; coding style
(setq-default c-basic-offset 4     ;;基本インデント量4
              tab-width 4          ;;タブ幅4
              ;;indent-tabs-mode t)  ;;インデントをタブでするかスペースでするか
              indent-tabs-mode nil)  ;;インデントをタブでするかスペースでするか

(add-hook 'c-mode-hook
          (lambda ()
            (c-set-style "stroustrup")
            (c-set-offset 'extern-lang-close '+)
            (c-set-offset 'extern-lang-open '+)
            ))
(add-hook 'c-mode-hook 'rainbow-delimiters-mode)

(setq c-default-style "linux"
      c-basic-offset 4)

;; org-mode config
(setq org-tree-slide-modeline-display 'outside)

;; disable menu bar
(menu-bar-mode -1)

;; 他のエディタなどがファイルを書き換えたらすぐにそれを反映する
;; auto-revert-modeを有効にする
(auto-revert-mode)

;;(add-to-list 'default-frame-alist '(font . Consolas ))
;;(set-face-attribute 'default t :font Consolas )

(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/atom-one-dark-theme-20160914.1337")
(load-theme 'atom-one-dark t)

;; modeline
(set-face-attribute 'mode-line nil
                    :foreground "gray0"
                    :background "#E5C07B"
                    :overline   "#E5C07B"
                    :underline  "#E5C07B")

;;======================================================================
;; キー配置 + キーバインド
;;======================================================================

;;コマンドキーをmetaキーに
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifire (quote super))

;;バッファのswitch
(global-set-key "\M-p" 'previous-buffer)
(global-set-key "\M-n" 'next-buffer)

;; 行を指定して移動
(global-set-key "\M-g" 'goto-line)

;; "C-h" を 後退 に
(global-set-key (kbd "C-h") 'delete-backward-char)

;; "C-k"で行削除
(setq kill-whole-line t)

;; ホイールでスクロール
(global-set-key [wheel-up] 'scroll-down-with-lines)
(global-set-key [wheel-down] 'scroll-up-with-lines)

;; gtags
(global-set-key "\M-t" 'gtags-find-tag)     ;関数の定義元へ
(global-set-key "\M-r" 'gtags-find-rtag)    ;関数の参照先へ
(global-set-key "\M-s" 'gtags-find-symbol)  ;変数の定義元/参照先へ
;;(global-set-key "\M-p" 'gtags-find-pattern)
(global-set-key "\M-f" 'gtags-find-file)    ;ファイルにジャンプ
(global-set-key "\C-t" 'gtags-pop-stack)    ;前のバッファに戻る

(setq gtags-select-mode-hook
      '(lambda ()
         (local-set-key "\C-m" 'gtags-select-tag)
         ))

;;======================================================================
;; スクリプト保存時に実行許可属性を設定
;;======================================================================
;; (defun make-file-executable ()
;;   "Make the file of this buffer executable, when it is a script source."
;;   (save-restriction
;;     (widen)
;;     (if (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
;;         (let ((name (buffer-file-name)))
;;           (or (equal ?. (string-to-char (file-name-nondirectory name)))
;;               (let ((mode (file-modes name)))
;;                 (set-file-modes name (logior mode (logand (/ mode 4) 73)))
;;                 (message (concat "Wrote " name " (+x)"))))))))
;; (add-hook 'after-save-hook 'make-file-executable)

;; ;;======================================================================
;; ;; 対応する括弧へ飛ぶ
;; ;; By an unknown contributor
;; ;;======================================================================
;; ;; "M-%" で対応する括弧に移動
;; (global-set-key "\M-%" 'match-paren)

;; (defun match-paren (arg)
;;   "Go to the matching paren if on a paren; otherwise insert %."
;;   (interactive "p")
;;   (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
;;         ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
;;         (t (self-insert-command (or arg 1)))))1

;;======================================================================
;; The Silver Serarcher(ag)
;;======================================================================
;;(setq default-process-coding-system 'utf-8-unix)  ; ag 検索結果のエンコード指定
;;(setq default-process-coding-system '(utf-8-dos . cp932))
(require 'ag)
(require 'wgrep-ag)
;;(setq ag-highlight-search t)  ; 検索キーワードをハイライト
;;(setq ag-reuse-buffers t)     ; 検索用バッファを使い回す (検索ごとに新バッファを作らない)

; wgrep
;;(add-hook 'ag-mode-hook '(lambda ()
;;                           (require 'wgrep-ag)
;;                           (setq wgrep-auto-save-buffer t)  ; 編集完了と同時に保存
;;                           (setq wgrep-enable-key "r")      ; "r" キーで編集モードに
;;                           (wgrep-ag-setup)))

;;======================================================================
;; GNU GLOBAL(gtags)
;;======================================================================
(require 'gtags)

(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\C-t" 'gtags-pop-stack)
         ))

(defun my-c-mode-update-gtags ()
  (let* ((file (buffer-file-name (current-buffer)))
     (dir (directory-file-name (file-name-directory file))))
    (when (executable-find "global")
      (start-process "gtags-update" nil
             "global" "-uv"))))

(add-hook 'after-save-hook
      'my-c-mode-update-gtags)

;;======================================================================
;; whitespace_mode
;;======================================================================
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

;; スペースは全角のみを可視化
(setq whitespace-space-regexp "\\(\u3000+\\)")

;; 保存前に自動でクリーンアップ
(setq whitespace-action '(auto-cleanup))

(global-whitespace-mode 1)

(defvar my/bg-color "#232323")
(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
;;(set-face-attribute 'whitespace-tab nil
;;                    :background nil ;;my/bg-color
;;                   :foreground nil ;;"LightSkyBlue"
;;                    :underline nil);;t)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "GreenYellow"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)


;;======================================================================
;; flycheck
;;======================================================================
;;(require 'flycheck)

;;======================================================================
;; その他
;;======================================================================

;; disable make backup file and auto save function
(setq make-backup-files nil)
(setq auto-save-default nil)

;; shellコマンドヒストリを補完
                                        ;(load-library "tails-comint-history")

;;info
(setq user-full-name "Koki Teraoka")
(setq user-mail-address "koki_teraoka@murata.com")

(set-cursor-color "yellow")

;;マウスホイールでスクロール
(defun scroll-down-with-lines ()
  "スクロールダウンを*行ごとに"
  (interactive)
  (scroll-down 4)
  )
(defun scroll-up-with-lines ()
  "スクロールアップを*行ごとに"
  (interactive)
  (scroll-up 4)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("1160f5fc215738551fce39a67b2bcf312ed07ef3568d15d53c87baa4fd1f4d4e" "a800120841da457aa2f86b98fb9fd8df8ba682cebde033d7dbf8077c1b7d677a" default)))
 '(display-time-mode t)
 '(package-selected-packages
   (quote
    (neotree setup-cygwin rainbow-delimiters flycheck flymake-cursor ripgrep atom-one-dark-theme monokai-theme gtags wgrep-ag smooth-scroll minimap color-theme auto-install ag)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))

;;'(default ((t (:family "Menlo" :foundry "unknown" :slant normal :weight normal :height 90 :width normal))))

(set-default-font "Inconsolata-10.5")
(set-face-font 'variable-pitch "Inconsolata-10.5")
(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0208
                  '("Takaoゴシック" . "unicode-bmp")
)

;; @ auto-install.el
;;(require 'auto-install)
;;(setq auto-install-directory "~/.emacs.d/auto-install/")
;;(auto-install-update-emacswiki-package-name t)
;;(auto-install-compatibility-setup)

;; @ redo+.el
(when (require 'redo+ nil t)
  (define-key global-map (kbd "C-_") 'redo))

;; @ smooth-scroll.el
(require 'smooth-scroll)
(smooth-scroll-mode t)

;; 縦方向のスクロール行数を変更する。
(setq smooth-scroll/vscroll-step-size 4)
;; 横方向のスクロール行数を変更する。
(setq smooth-scroll/hscroll-step-size 4)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
