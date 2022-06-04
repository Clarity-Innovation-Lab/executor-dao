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
		;; bobby transfers to daisy
		(try! (contract-call? .ede000-governance-token edg-transfer u500 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG))
		(print "Unit Test: Ensure dao can't transfer edg if token is locked.")
		(ok true)
	)
)
