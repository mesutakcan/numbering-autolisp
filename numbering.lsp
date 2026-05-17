; -----------------------------------
; AutoCAD'de sıralı numara yaz
; Artan/Azalan ve başlangıç seçenekli
; -----------------------------------
; © 2022 Mesut Akcan
; makcan@gmail.com
; mesutakcan.blogspot.com
; youtube.com/mesutakcan
; github.com/mesutakcan
; -----------------------------------
; 11/9/2022
; V1.0 R1
;------------------------------------

(defun c:NY ( / *error mn eyariCap esayi eartis)
	
	;----- Hata olursa ----------
	(defun *error* (msg)
		(princ "Error: ") (princ msg) ; Hata mesajını yaz
		(vla-endundomark acadDoc) ; UndoMark sonlandır
		(princ)
	)
	
	; İlk defa çalıştırılıyorsa varsayılan değerleri ata
	(if (= yariCap nil) (setq yariCap 3))
	(if (= sayi nil) (setq sayi 1))
	(if (= artis nil) (setq artis 1))
	
	(setq
		eyariCap yariCap ; önceki değer Yarıçap
		esayi sayi ; önceki değer Sayı
		eartis artis ; önceki değer Artış
		yariCap (getdist (strcat "\nDaire yarıçapı: <" (rtos yariCap) ">:"))
		sayi (getint (strcat "\nBaşlangıç sayısı <" (rtos sayi) ">:"))
		artis (getint (strcat "\nArtış sayısı: <" (rtos artis) ">"))
	)
	
	; Enter, Boşluk veya Sağ tık ile geçildiyse önerilen değeri al
	(if (= yariCap nil) (setq yariCap eyariCap))
	(if (= sayi nil) (setq sayi esayi))
	(if (= artis nil) (setq artis eartis)) 
	
	(vla-startundomark acadDoc) ; UndoMark başlat
	
	
	(while
		(setq mn (getpoint "\nMerkez nokta:")) ; Daire merkez noktasını belirle
		(entmake ; daire çiz
			(list
				(cons 0 "CIRCLE")
				(cons 10 mn) ; merkez nokta
				(cons 40 yariCap) ;yarıçap
			)
		)
		(entmake ; numarayı yaz
			(list
				(cons 0 "TEXT")
				(cons 1 (itoa sayi)) ;yazı
				(cons 10 mn) ; yazı ekleme noktası1
				(cons 11 mn) ; yazı ekleme noktası2
				(cons 40 (* yariCap 0.8)) ; yazı yüksekliği. Yarıçapın %80'i kadar
				(cons 72 1) ; yatay yazı yaslama -> 1 = Center - Merkez
				(cons 73 2) ; dikey yazı yaslama -> 2 = Middle - Orta
			)
		)
		(setq sayi (+ sayi artis)) ; sayıyı artış miktarı kadar arttır
	)
	(vla-endundomark acadDoc) ; UndoMark sonlandır
	(princ)
)

(vl-load-com)
(setq acadDoc (vla-get-activedocument (vlax-get-acad-object))) ; aktif doküman
(princ "\nUygulama yüklendi. Çalıştırmak için NY komutunu kullanın.")
(princ)
