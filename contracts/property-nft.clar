;; Property NFT Contract for HomeRentDAO
;; Author: micheal winter
;; License: MIT

;; Contract to mint NFTs representing properties and bookable dates

(define-data-var admin principal tx-sender)

;; Unique NFT ID counter
(define-data-var next-id uint u1)

;; NFT metadata: maps NFT ID to metadata string
(define-map nft-metadata uint (string-utf8 256))

;; NFT owner mapping (SIP-010 style)
(define-map nft-owners uint principal)

;; Verified hosts who can mint NFTs
(define-map verified-hosts principal bool)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-NOT-VERIFIED-HOST u101)
(define-constant ERR-NOT-OWNER u102)
(define-constant ERR-TOKEN-NOT-FOUND u103)
(define-constant ERR-ALREADY-VERIFIED u104)
(define-constant ERR-NOT-FOUND u105)

;; Utils
(define-private (is-admin) (is-eq tx-sender (var-get admin)))

;; Admin functions

(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (var-set admin new-admin)
    (ok true)
  )
)

(define-public (add-verified-host (host principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-none (map-get? verified-hosts host)) (err ERR-ALREADY-VERIFIED))
    (map-set verified-hosts host true)
    (ok true)
  )
)

(define-public (remove-verified-host (host principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-some (map-get? verified-hosts host)) (err ERR-NOT-FOUND))
    (map-delete verified-hosts host)
    (ok true)
  )
)

;; NFT Functions

(define-public (mint (metadata (string-utf8 256)))
  (begin
    (asserts! (is-some (map-get? verified-hosts tx-sender)) (err ERR-NOT-VERIFIED-HOST))
    (let (
      (new-id (var-get next-id))
    )
      (map-set nft-owners new-id tx-sender)
      (map-set nft-metadata new-id metadata)
      (var-set next-id (+ new-id u1))
      (ok new-id)
    )
  )
)

(define-public (transfer (token-id uint) (to principal))
  (begin
    (let ((owner (map-get? nft-owners token-id)))
      (asserts! (is-some owner) (err ERR-TOKEN-NOT-FOUND))
      (asserts! (is-eq tx-sender (unwrap! owner (err ERR-TOKEN-NOT-FOUND))) (err ERR-NOT-OWNER))
      (map-set nft-owners token-id to)
      (ok true)
    )
  )
)

(define-public (burn (token-id uint))
  (begin
    (let ((owner (map-get? nft-owners token-id)))
      (asserts! (is-some owner) (err ERR-TOKEN-NOT-FOUND))
      (asserts! (is-eq tx-sender (unwrap! owner (err ERR-TOKEN-NOT-FOUND))) (err ERR-NOT-OWNER))
      (map-delete nft-owners token-id)
      (map-delete nft-metadata token-id)
      (ok true)
    )
  )
)

;; Read-only functions

(define-read-only (get-owner (token-id uint))
  (default-to none (map-get? nft-owners token-id))
)

(define-read-only (get-metadata (token-id uint))
  (default-to none (map-get? nft-metadata token-id))
)

(define-read-only (is-verified-host (host principal))
  (default-to false (map-get? verified-hosts host))
)

(define-read-only (get-next-id)
  (ok (var-get next-id))
)

(define-read-only (get-admin)
  (ok (var-get admin))
)

;; SIP-010: balance-of
(define-read-only (balance-of (owner principal))
  (let (
    (ids (filter
      (lambda (pair)
        (is-eq (some owner) (map-get? nft-owners (get first pair))))
      (map-to-list nft-owners)
    ))
  )
    (ok (len ids))
  )
)

;; SIP-010: owner-of
(define-read-only (owner-of (token-id uint))
  (default-to none (map-get? nft-owners token-id))
)

;; SIP-010: get-token-uri
(define-read-only (get-token-uri (token-id uint))
  (default-to none (map-get? nft-metadata token-id))
)
