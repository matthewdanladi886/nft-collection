;; Removed invalid clarity-version function call, converted to comment
;; clarity-version 1.1

;; ==============================================================
;; NFT COLLECTION CONTRACT
;; A minimal SIP-009 compliant NFT contract for digital assets
;; ==============================================================

;; ---------------------------
;; CONSTANTS & ERRORS
;; ---------------------------
(define-constant ERR-NOT-OWNER (err u100))
(define-constant ERR-NOT-AUTHORIZED (err u101))
(define-constant ERR-TOKEN-NOT-FOUND (err u102))
(define-constant ERR-ZERO-ID (err u103))

;; ---------------------------
;; DATA VARIABLES
;; ---------------------------
(define-data-var owner principal tx-sender)
(define-data-var total-supply uint u0)

;; NFT definition
(define-non-fungible-token ecoNFT uint)

;; Fixed non-ASCII characters in map definition
;; Mapping for optional metadata URI (token-id to metadata URI)
(define-map token-metadata
  uint
  {uri: (string-ascii 256)})

;; ---------------------------
;; READ-ONLY FUNCTIONS
;; ---------------------------

(define-read-only (get-owner)
  (ok (var-get owner)))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

;; Fixed match syntax with proper variable binding
(define-read-only (get-token-uri (token-id uint))
  (match (map-get? token-metadata token-id)
    entry (ok (get uri entry))
    ERR-TOKEN-NOT-FOUND))

;; ---------------------------
;; PRIVATE HELPERS
;; ---------------------------

(define-private (only-owner)
  (is-eq tx-sender (var-get owner)))

;; ---------------------------
;; PUBLIC FUNCTIONS
;; ---------------------------

;; --------------------------------------------------------------
;; mint:
;; Owner mints a new NFT to a recipient with optional metadata URI.
;; --------------------------------------------------------------
(define-public (mint (recipient principal) (token-id uint) (uri (string-ascii 256)))
  (if (not (only-owner))
      ERR-NOT-OWNER
      (if (<= token-id u0)
          ERR-ZERO-ID
          (begin
            (try! (nft-mint? ecoNFT token-id recipient))
            (map-set token-metadata token-id {uri: uri})
            (var-set total-supply (+ (var-get total-supply) u1))
            (ok {status: "mint-success", id: token-id, to: recipient})))))

;; --------------------------------------------------------------
;; transfer:
;; Transfers ownership of an existing NFT from sender to recipient.
;; --------------------------------------------------------------
(define-public (transfer (token-id uint) (recipient principal))
  (let ((current-owner (unwrap! (nft-get-owner? ecoNFT token-id) ERR-TOKEN-NOT-FOUND)))
    (if (is-eq current-owner tx-sender)
        (begin
          (try! (nft-transfer? ecoNFT token-id tx-sender recipient))
          (ok {status: "transfer-success", id: token-id, to: recipient}))
        ERR-NOT-AUTHORIZED)))

;; --------------------------------------------------------------
;; get-owner-of:
;; Returns the current owner of a specific NFT.
;; --------------------------------------------------------------
;; Fixed match syntax with proper variable binding
(define-read-only (get-owner-of (token-id uint))
  (match (nft-get-owner? ecoNFT token-id)
    owner-principal (ok owner-principal)
    ERR-TOKEN-NOT-FOUND))
