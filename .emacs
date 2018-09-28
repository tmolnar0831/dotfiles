
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")))

(setq package-list '(yaml-mode
                     elpy
                     py-autopep8
                     flycheck
                     markdown-mode
                     ansible
                     python-mode
                     jinja2-mode
                     company
                     company-ansible
                     puppet-mode
                     undo-tree
                     magit
                     slime
                     ace-window
                     hydra
                     avy))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; Set the starting theme
(load-theme 'wheatgrass t)

;; Highlight color for the current theme
(require 'hl-line)
(set-face-background 'hl-line "#123d22")

;; Use the "normal" syntax highlight under the hl-line
(set-face-foreground 'highlight nil)

;; Sunrise and sunset for the calendar
;; It is a dependency of the theme picker
(setq calendar-latitude 47.4979)
(setq calendar-longitude 19.0402)
(setq calendar-location-name "Budapest, HU")
(setq calendar-standard-time-zone-name "CET")
(setq calendar-daylight-time-zone-name "CEST")
(setq tmolnar/sunrise (nth 1 (split-string (sunrise-sunset))))
(setq tmolnar/sunset (nth 4 (split-string (sunrise-sunset))))

;; Theme picker
(defun tmolnar/check-current-theme ()
  "Returns the current enabled theme as a string, or returns nil.
This function reads the custom-enabled-themes variable.
I switch between a light and a dark theme."
  (cond ((member 'whiteboard custom-enabled-themes) "whiteboard")
        ((member 'wheatgrass custom-enabled-themes) "wheatgrass")
        (t nil)))

(defun tmolnar/set-hl-line ()
  "Sets the hl-line color matching to the theme, or returns nil."
  (let ((current-theme (tmolnar/check-current-theme)))
    (cond ((equal current-theme "whiteboard")
           (set-face-background 'hl-line "#e2e2e2"))
          ((equal current-theme "wheatgrass")
           (set-face-background 'hl-line "#123d22"))
          (t nil)))
  (set-face-foreground 'highlight nil))

(defun tmolnar/set-my-theme (theme)
  "Sets the required theme.
(tmolnar/set-my-theme THEME)
THEME must be a symbol."
  (mapcar #'disable-theme custom-enabled-themes)
  (load-theme theme t)
  (tmolnar/set-hl-line)
  (message "%s theme has been set" theme))

(defun tmolnar/set-theme ()
  "Command that loads and sets the required theme.
It toggles between the wheatgrass and whiteboard themes."
  (interactive)
  (let ((current-theme (tmolnar/check-current-theme)))
    (cond ((equal current-theme "whiteboard")
           (tmolnar/set-my-theme 'wheatgrass))
          ((equal current-theme "wheatgrass")
           (tmolnar/set-my-theme 'whiteboard))
          (t nil))))

;; Bindings
(global-set-key (kbd "<f11>") 'tmolnar/set-theme)
(run-at-time tmolnar/sunrise nil 'tmolnar/set-my-theme 'whiteboard)
(run-at-time tmolnar/sunset nil 'tmolnar/set-my-theme 'wheatgrass)

(tool-bar-mode -1)

(menu-bar-mode -1)

(scroll-bar-mode -1)

(setq inhibit-startup-screen 1)

(setq inhibit-startup-echo-area-message 1)

(setq initial-scratch-message nil)

(setq split-width-threshold 1)

(setq echo-keystrokes 0.1)

(blink-cursor-mode -1)

(setq-default cursor-type 'hbar)

;; Always show the matching parenthesis
(show-paren-mode 1)

;; Show the expression or the matching parenthesis
(setq show-paren-style 'mixed)

(setq ring-bell-function 'ignore)

;; Macro that creates full paths to the config files
(defmacro tmolnar/find-econf-files (filename)
  "Look for the configuration file in the default directory and /~"
  `(if (file-exists-p (concat user-emacs-directory ,filename))
       (concat user-emacs-directory ,filename)
     (expand-file-name ,filename "~/")))

;; Function that opens the provided config file list
(defun tmolnar/open-emacs-config-files ()
  "Looping over the list of configuration files and opening them"
  (interactive)
  (let ((my-files '("init.el" "emacs.org" ".emacs")))
    (dolist (f my-files)
      (find-file (tmolnar/find-econf-files f)))))

(global-unset-key (kbd "<f10>"))                                ; Unset the F10
(global-set-key (kbd "<f12>") 'tmolnar/open-emacs-config-files) ; F12 - open Emacs files
(global-set-key (kbd "M-2") 'end-of-buffer)                     ; Move point to the end of buffer
(global-set-key (kbd "M-3") 'beginning-of-buffer)               ; Move point to the beginning of buffer

(setq user-full-name "Tamás Molnár"
      user-mail-address "tmolnar0831@gmail.com")

(require 'server)
(unless (server-running-p)
  (server-start))

(setq confirm-kill-emacs 'y-or-n-p)

(global-auto-revert-mode t)

(setq ediff-split-window-function 'split-window-horizontally)

(savehist-mode 1)

(setq calendar-week-start-day 1)

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default indent-tabs-mode nil)

(if (and (file-exists-p "/usr/bin/sbcl")
         (file-executable-p "/usr/bin/sbcl"))
    (setq inferior-lisp-program "/usr/bin/sbcl")
  (setq inferior-lisp-program "/usr/bin/clisp"))

(put 'narrow-to-region 'disabled nil)

(put 'erase-buffer 'disabled nil)

(setq tramp-default-method "ssh")

(setq auto-window-vscroll nil)

(setq backup-by-copying t)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(global-undo-tree-mode)

(setq global-linum-mode nil)
(add-hook 'prog-mode-hook 'linum-mode)

(add-to-list 'auto-mode-alist '("\\.j2\\'" . jinja2-mode))

(global-hl-line-mode)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq ibuffer-saved-filter-groups
      '(("tmolnar/ibuffer-groups"
         ("Org Agenda" (name . "\*Org Agenda\*"))
         ("Emacs Configuration files" (or (filename . "emacs\.d")
                                          (filename . "\.emacs")))
         ("ERC" (mode . erc-mode))
         ("Common Lisp" (mode . lisp-mode))
         ("Perl" (mode . perl-mode))
         ("TCL/Tk" (mode . tcl-mode))
         ("Python" (mode . python-mode))
         ("Ansible/YAML" (mode . yaml-mode))
         ("Jinja2" (mode . jinja2-mode))
         ("Org Mode" (or (mode . org-mode)
                         (filename . "org")))
         ("Tramp" (or (name . "tramp")
                      (filename . "scp")))
         ("Help" (or (name . "\*Help\*")
                     (name . "\*Apropos\*")
                     (name . "\*info\*"))))))

(add-hook 'ibuffer-mode-hook
          '(lambda ()
             (ibuffer-switch-to-saved-filter-groups "tmolnar/ibuffer-groups")))

(add-hook 'ibuffer-mode-hook
    '(lambda ()
       (ibuffer-auto-mode 1)
       (ibuffer-switch-to-saved-filter-groups "tmolnar/ibuffer-groups")))

(setq ibuffer-expert t)

(setq ibuffer-show-empty-filter-groups nil)

(setq ido-enable-flex-matching t)

(ido-mode 1)

(setq ido-everywhere t)

(setq ido-create-new-buffer 'always)

(add-hook 'after-init-hook 'global-company-mode)

(require 'company-ansible)
(add-to-list 'company-backends 'company-ansible)

(setq company-dabbrev-other-buffers t)

(setq company-show-numbers t)

(setq company-idle-delay 0)

(setq company-minimum-prefix-length 2)

(add-hook 'yaml-mode-hook '(lambda () (ansible 1)))

;; Loading the secrets for ERC
(if (file-exists-p (expand-file-name "~/.emacs.d/.erc-secret.el"))
    (load (expand-file-name "~/.emacs.d/.erc-secret.el")))

;; Rename server buffers to reflect the current network name
(setq erc-rename-buffers t)

;; Interpret mIRC-style color commands in IRC chats
(setq erc-interpret-mirc-color t)

;; Kill buffers for channels after /part
(setq erc-kill-buffer-on-part t)

;; Kill buffers for private queries after quitting the server
(setq erc-kill-queries-on-quit t)

;; Kill buffers for server messages after quitting the server
(setq erc-kill-server-buffer-on-quit t)

(defun tmolnar/mark-read ()
  "Mark buffer as read up to current line."
  (let ((inhibit-read-only t)) ; disregard the read-only status of the buffer
    (put-text-property
     (point-min) (line-beginning-position)
     'face       'font-lock-comment-face)))

(defun tmolnar/bury-buffer ()
  "Bury buffer and maybe close its window."
  (interactive)
  (tmolnar/mark-read)
  (bury-buffer)
  (when (cdr (window-list nil 'nomini))
    (delete-window)))

(eval-after-load 'erc
  '(define-key erc-mode-map (kbd "<escape>")
     #'tmolnar/bury-buffer))

;; Hide join, part and quit messages
(setq erc-hide-list '("JOIN" "PART" "QUIT"))

(setq magit-diff-highlight-indentation nil
      magit-diff-highlight-trailing nil
      magit-diff-paint-whitespace nil
      magit-diff-highlight-hunk-body nil
      magit-diff-refine-hunk nil)

(remove-hook 'magit-refs-sections-hook 'magit-insert-tags)

(remove-hook 'server-switch-hook 'magit-commit-diff)

(setq vc-handled-backends nil)

(elpy-enable)

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(global-set-key (kbd "M-o") 'ace-window)

;; Zooming
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

;; Resize windows
(defhydra hydra-resize-windows (global-map "<f3>")
  "Resize windows"
  ("n" enlarge-window-horizontally "Enlarge window horizontally")
  ("m" shrink-window-horizontally "Shrink window horizontally")
  ("j" enlarge-window "Enlarge window")
  ("k" shrink-window "Shrink window"))

(global-set-key (kbd "C-;") 'avy-goto-char-timer)

(if (file-exists-p (expand-file-name "init.el" user-emacs-directory))
    (load (expand-file-name "init.el" user-emacs-directory)))
