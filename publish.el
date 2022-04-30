;;; publish.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 GTrunSec
;;
;; Author: GTrunSec <https://github.com/gtrunsec>
;; Maintainer: GTrunSec <gtrunsec@hardenedlinux.org>
;; Created: April 15, 2021
;; Modified: April 15, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/gtrun/publish
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
(require 'org)
(require 'ox-publish)
(require 'org-id)
(require' find-lisp)


(with-eval-after-load 'ox
  (require 'ox-hugo)
  (setq org-src-preserve-indentation t))

(defun gt/publish (file)
  (with-current-buffer (find-file-noselect file)
    (setq org-id-locations-file (expand-file-name ".orgids" "./"))
    (setq org-hugo-base-dir "..")
    (let (;;(org-id-extra-files (find-lisp-find-files "~/Dropbox/org-notes/braindump" "\.org$"))
          )
      (org-hugo-export-wim-to-md))))

(provide 'publish)
;;; publish.el ends here
