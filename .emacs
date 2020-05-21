(xterm-mouse-mode 1)


(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)


(global-set-key '[(control tab)]                          'cycle-buffers)
(global-set-key [(control home)]                         'beginning-of-buffer) ;
(global-set-key [(control end)]                          'end-of-buffer) ;
(global-set-key  [f1]                                     'help) ;
(global-set-key  [f2]                                     'save-buffer) ;
(global-set-key  [f3]                                     'isearch-repeat-forward) ;
(global-set-key [(control f4)]                           'previous-error) ;
(global-set-key  [(control up)]                           'delete-other-windows) ;
(global-set-key  [(control down)]                         'split-window-vertically) ;
(global-set-key [(meta down)]                            'split-window-horizontally) ;
(global-set-key [(meta up)]                              'next-multiframe-window) ;
(global-set-key  [(control w)]                            'next-multiframe-window) ;
(global-set-key [(meta left)]                            'cyclebuffer-backward) ;
(global-set-key [(meta right)]                           'cyclebuffer-forward) ;
(global-set-key  [f6]                                     'switch-to-next-buffer) ;
(global-set-key  [f7]                                     'compile-gmake) ;
(global-set-key  [f8]                                     'kill-current-buffer) ;
(global-set-key  [f12]                                    'eval-current-buffer) ;
(global-set-key  "\C-f"                                   'isearch-forward-regexp) ;
(global-set-key  [(meta f)]                               'grep-find-recursive-cpp) ;
(global-set-key  "\C-o"                                   'find-file) ;
(global-set-key  [(meta o)]                               'find-file) ;
(global-set-key  "\C-y"                                   'kill-line) ;
(global-set-key  "\C-s"                                   'shell) ;
(global-set-key  "\C-z"                                   'advertised-undo) ;
(global-set-key  "\C-u"                                   'advertised-undo) ;
(global-set-key  "\C-q"                                   'save-buffers-kill-terminal) ;
(global-set-key  [(meta h)]                               'query-replace-regexp) ;
(global-set-key  "\C-h"                                   'backward-delete-char) ;
(global-set-key  "\C-t"                                   'find-tag ) ;
(global-set-key  "\C-n"                                   'find-tag-next) ;
(global-set-key  [(meta g)]                               'goto-line) ;
(global-set-key  "\C-p"                                   'gud-print) ;
(global-set-key  "\C-ci"                                  'ci) ;
(global-set-key  "\C-co"                                  'co) ;
(global-set-key  "\C-ct"                                  'ct) ;
(global-set-key  "\C-cf"                                  'cf) ;
(global-set-key  "\C-cd"                                  'change-home-directory) ;
(global-set-key  "\C-a"                                   'find-file-at-point) ;
(global-set-key  [(meta b)]                               'bookmark-set) ;
(global-set-key  "\C-b"                                   'bookmark-bmenu-list) ;
(global-set-key  "\C-l"                                   'list-file-buffers) ;
(global-set-key  [(meta l)]                               'buffer-menu) ;
(global-set-key  "\C-x\C-b"                               'list-buffers) ;
