SELECT  bb.bank_name,
        bb.bank_branch_name,
        bb.Address_line1,
        bb.Address_line2,
        bb.address_line3,
        bb.Bank_num,
        bb.Bank_number,
        bb.EFT_SWIFT_CODE,
        ba.bank_account_name,
        ba.bank_account_num,
        ba.account_type,
        ba.iban_number
FROM    ap_bank_branches bb,
        ap_bank_accounts_all ba,
        ap_bank_account_uses_all abau,
        po_vendor_sites_all vs,
        po_vendors v
WHERE   bb.bank_branch_id = ba.bank_branch_id
AND     ba.bank_account_id = abau.external_bank_account_id
AND     abau.vendor_site_id = vs.vendor_site_id
AND     vs.vendor_id = v.vendor_id
AND     NVL(bb.end_date, SYSDATE + 1) > SYSDATE
AND     NVL(ba.inactive_date, SYSDATE + 1) > SYSDATE
AND     NVL(abau.end_date, SYSDATE+ 1) > SYSDATE
AND     NVL(vs.inactive_date, SYSDATE + 1) > SYSDATE
AND     NVL(v.end_date_active, SYSDATE + 1) > SYSDATE;