;; Title: EDP001-1 Dev Fund
;; Author: Mike Cohen
;; Synopsis:
;; Updates governance and membership type of the DAO.
;; Description:
;; If this proposal passes, sets the governance token transfer lock
;; making it only ossible to mint and burn the tokens - no secondary
;; market for governance tokens is possible.

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
	(begin
		(contract-call? .ede000-governance-token set-transfer-lock false)
	)
)
