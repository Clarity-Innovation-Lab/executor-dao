;; An example external contract to show how the ExecutorDAO is able to
<<<<<<< HEAD
;; manage external contracts that might not be aware of the DAO. See
;; edp003-manage-escrow-nft for more details.
=======
;; add external contracts to an allowlist. These contracts may not be aware of the DAO. See
;; edp003-allowlist-escrow-nft for more details.
>>>>>>> main

(impl-trait .ownable-trait.ownable-trait)

(define-constant err-not-contract-owner (err u100))
<<<<<<< HEAD
(define-constant err-not-allowed (err u101))
=======
(define-constant err-not-allowlisted (err u101))
>>>>>>> main
(define-constant err-unknown-escrow (err u102))
(define-constant err-wrong-nft (err u103))
(define-constant err-not-nft-owner (err u104))

(define-data-var contract-owner principal tx-sender)
<<<<<<< HEAD
(define-map nft-allow principal bool)
=======
(define-map nft-allowlist principal bool)
>>>>>>> main
(define-map nfts-in-escrow {token-id: uint, recipient: principal} {owner: principal, price: uint, asset: principal})

(define-trait sip009-transferable
	(
		(transfer (uint principal principal) (response bool uint))
	)
)

(define-private (is-owner)
	(ok (asserts! (is-eq (var-get contract-owner) tx-sender) err-not-contract-owner))
)

(define-read-only (get-contract-owner)
	(ok (var-get contract-owner))
)

(define-public (set-contract-owner (new-owner principal))
	(begin
		(try! (is-owner))
		(ok (var-set contract-owner new-owner))
	)
)

<<<<<<< HEAD
(define-read-only (is-allowed (nft principal))
	(default-to false (map-get? nft-allow nft))
)

(define-public (set-allowed (nft principal) (enabled bool))
	(begin
		(try! (is-owner))
		(ok (map-set nft-allow nft enabled))
=======
(define-read-only (is-allowlisted (nft principal))
	(default-to false (map-get? nft-allowlist nft))
)

(define-public (set-allowlisted (nft principal) (enabled bool))
	(begin
		(try! (is-owner))
		(ok (map-set nft-allowlist nft enabled))
>>>>>>> main
	)
)

(define-read-only (get-escrow (token-id uint) (recipient principal))
	(map-get? nfts-in-escrow {token-id: token-id, recipient: recipient})
)

(define-private (send-nft (token-id uint) (recipient principal) (nft <sip009-transferable>))
	(as-contract (contract-call? nft transfer token-id tx-sender recipient))
)

(define-public (place-in-escrow (token-id uint) (recipient principal) (amount uint) (nft <sip009-transferable>))
	(begin
<<<<<<< HEAD
		(asserts! (is-allowed (contract-of nft)) err-not-allowed)
=======
		(asserts! (is-allowlisted (contract-of nft)) err-not-allowlisted)
>>>>>>> main
		(map-set nfts-in-escrow {token-id: token-id, recipient: recipient} {owner: tx-sender, price: amount, asset: (contract-of nft)})
		(contract-call? nft transfer token-id tx-sender (as-contract tx-sender))
	)
)

(define-public (pay-and-redeem (token-id uint) (nft <sip009-transferable>))
	(let ((escrow (unwrap! (get-escrow token-id tx-sender) err-unknown-escrow)))
		(asserts! (is-eq (contract-of nft) (get asset escrow)) err-wrong-nft)
		(map-delete nfts-in-escrow {token-id: token-id, recipient: tx-sender})
		(try! (stx-transfer? (get price escrow) tx-sender (get owner escrow)))
		(send-nft token-id tx-sender nft)
	)
)

(define-public (cancel-escrow (token-id uint) (recipient principal) (nft <sip009-transferable>))
	(let ((escrow (unwrap! (get-escrow token-id recipient) err-unknown-escrow)))
		(asserts! (is-eq (get owner escrow) tx-sender) err-not-nft-owner)
		(asserts! (is-eq (contract-of nft) (get asset escrow)) err-wrong-nft)
		(map-delete nfts-in-escrow {token-id: token-id, recipient: recipient})
		(send-nft token-id tx-sender nft)
	)
)

