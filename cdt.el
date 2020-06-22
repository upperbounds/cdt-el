(require 'websocket)

(defcustom cdt-hostname
  "localhost"
  "chrome devtools host"
  :type nil
  :group nil)

(defcustom cdt-port
  9222
  "chrome devtools port"
  :type nil
  :group nil)

(defun cdt-host () (format "http://%s:%s" cdt-hostname cdt-port))

(defvar ws)

(defun cb (status)
  (switch-to-buffer (current-buffer))
  (goto-char url-http-end-of-headers)
  (let ((json-object-type 'plist)
        (json-key-type 'symbol)
        (json-array-type 'vector))
    (let* ((result (json-read))
		   (pages (make-hash-table :test 'equal))
		   )
	  (mapc (lambda (el)
              (puthash
			   (plist-get el 'title)
               (plist-get el 'webSocketDebuggerUrl)
               pages))
            result)
	  ;; (setq cb-info thing)
	  (let* ((pick (completing-read "Pick" (hash-table-keys pages))))
		(debug pick)
		(message (format "you picked %s" (gethash pick pages)))
		(let* ((tls-checktrust nil)
			   (wstest-closed nil)
			   (wstest-msg)
			   (ws-l
				(websocket-open
				 (gethash pick pages)
				 :on-message (lambda (_websocket frame)
							   (message "got message")
							   (setq wstest-msg (websocket-frame-text frame)))
				 :on-close (lambda (_websocket) (setq wstest-closed t))))
			   )
		  (setq ws ws-l)
		  )
		)
	  )))

(defun pages ()
  (let ((url-request-method "GET"))
	  (url-retrieve (format "%s/json" (cdt-host)) 'cb)))

;; (websocket-close ws)
