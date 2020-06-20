(require 'websocket)

(defvar ws)

(defvar ws-url "ws://localhost:9222/devtools/page/CC7A7701FCE2FE1E0F4447961262AC8A")

(let* ((tls-checktrust nil)
       (wstest-closed nil)
       (wstest-msg)
       (ws-l
        (websocket-open
         ws-url
         :on-message (lambda (_websocket frame)
					   (message "got message")
                       (setq wstest-msg (websocket-frame-text frame)))
         :on-close (lambda (_websocket) (setq wstest-closed t))))
	   )
  (setq ws ws-l)

  )

;;(websocket-send-text ws "Hi!")

(websocket-close ws)
