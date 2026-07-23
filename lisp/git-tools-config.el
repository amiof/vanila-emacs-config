;; git ediff config for show diff current with HEAD
(defvar my-ediff-head-temp-buffer nil
  "Temporary buffer used by `my/ediff-with-git-rev'.")

(defun my-ediff-head--cleanup ()
  "Kill temporary revision buffer after Ediff quits."
  (when (and (bound-and-true-p my-ediff-head-temp-buffer)
             (buffer-live-p my-ediff-head-temp-buffer))
    (kill-buffer my-ediff-head-temp-buffer)))

(defun my/ediff-with-git-rev (&optional rev)
  "Compare current buffer with a Git revision using Ediff.
Default revision is HEAD.
With prefix argument, ask for revision."
  (interactive
   (list
    (if current-prefix-arg
        (read-string "Revision: " "HEAD")
      "HEAD")))
  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file"))

  (let* ((file (buffer-file-name))
         (root (or (and (fboundp 'magit-toplevel)
                        (ignore-errors (magit-toplevel)))
                   (and (fboundp 'vc-root-dir)
                        (ignore-errors (vc-root-dir)))
                   (locate-dominating-file file ".git")))
         (default-directory (or root default-directory))
         (rel (if root
                  (file-relative-name file root)
                (file-name-nondirectory file)))
         (rev (or rev "HEAD"))
         (rev-buf (generate-new-buffer
                   (format "*%s:%s*" rev (file-name-nondirectory file)))))

    (unless root
      (user-error "Not inside a Git repository"))

    (with-current-buffer rev-buf
      (let ((status (call-process "git" nil t nil
                                  "show" (concat rev ":" rel))))
        (unless (zerop status)
          ;; If file does not exist in REV yet, show empty buffer.
          (erase-buffer)))
      (setq buffer-read-only t)
      ;; Try to enable proper syntax highlighting.
      (let ((buffer-file-name file))
        (ignore-errors (set-auto-mode))))

    ;; Left: old version / HEAD
    ;; Right: current buffer
    (ediff-buffers rev-buf (current-buffer))

    ;; Cleanup temp buffer when Ediff quits.
    (when (bound-and-true-p ediff-control-buffer)
      (with-current-buffer ediff-control-buffer
        (setq-local my-ediff-head-temp-buffer rev-buf)
        (add-hook 'ediff-quit-hook #'my-ediff-head--cleanup nil t)))))


(defvar my-ediff-changed-files-history nil
  "History for `my/ediff-changed-files'.")

(defun my-git-root ()
  "Return Git repository root for current directory."
  (or (and (fboundp 'magit-toplevel)
           (ignore-errors (magit-toplevel)))
      (and (fboundp 'vc-root-dir)
           (ignore-errors (vc-root-dir)))
      (locate-dominating-file default-directory ".git")))

(defun my-git-changed-files (&optional rev root)
  "Return list of changed files compared to REV, default HEAD.
Also includes untracked files."
  (let* ((root (or root (my-git-root))))
    (unless root
      (user-error "Not inside a Git repository"))
    (let ((default-directory root)
          (rev (or rev "HEAD")))
      (with-temp-buffer
        ;; فایل‌های tracked که نسبت به REV تغییر کرده‌اند
        (call-process "git" nil t nil
                      "diff" "--name-only" "-z" rev)

        ;; فایل‌های untracked جدید را هم اضافه می‌کند
        (call-process "git" nil t nil
                      "ls-files" "--others" "--exclude-standard" "-z")

        (delete-dups
         (sort
          (split-string (buffer-string) "\0" t)
          #'string-lessp))))))

(defun my/ediff-changed-files (&optional rev)
  "Choose a changed file with completion and Ediff it against REV.
Default REV is HEAD.
With prefix argument, ask for REV."
  (interactive
   (list
    (if current-prefix-arg
        (let ((r (read-string "Revision: " "HEAD")))
          (if (string-empty-p (string-trim r))
              "HEAD"
            r))
      "HEAD")))

  (let* ((root (my-git-root)))
    (unless root
      (user-error "Not inside a Git repository"))

    (let* ((default-directory root)
           (files (my-git-changed-files rev root)))

      (unless files
        (user-error "No changed files"))

      (let* ((prompt (format "Ediff vs %s: " (or rev "HEAD")))
             (choice
              (if (and (require 'consult nil t)
                       (fboundp 'consult--read))
                  (consult--read files
                                 :prompt prompt
                                 :require-match t
                                 :sort t
                                 :history 'my-ediff-changed-files-history)
                (completing-read prompt
                                 files
                                 nil t nil
                                 'my-ediff-changed-files-history)))
             (file (expand-file-name choice root)))

        (with-current-buffer (find-file-noselect file)
          (my/ediff-with-git-rev rev))))))

(setq ediff-window-setup-function #'ediff-setup-windows-plain)
(setq ediff-split-window-function #'split-window-horizontally)

(provide 'git-tools-config)
