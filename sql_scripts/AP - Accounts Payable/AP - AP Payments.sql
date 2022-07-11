SELECT  ac.attribute1,
        ac.attribute2,
        ac.attribute3,
        ac.attribute4,
        ac.attribute5,
        ac.attribute6,
        ac.attribute7,
        ac.attribute8,
        ac.attribute9,
        ac.attribute10,
        ac.attribute11,
        ac.attribute12,
        ac.attribute13,
        ac.attribute14,
        ac.attribute15,
        ac.checkrun_name batch_name,
        ac.creation_date,
        fu_cr.user_name created_by,
        acs.name document,
        ac.check_number document_num,
        ac.last_update_date,
        fu_upd.user_name last_updated_by,
        ac.address_line1||',  '||ac.address_line2||',  '||ac.address_line3||',  '||ac.address_line4 paid_to_address,
        ac.vendor_name paid_to_name,
        ac.currency_code payment_currency,
        ac.amount payment_amount,
        ac.check_date payment_date,
        alc.displayed_field payment_method,
        aba.bank_account_name remit_to_account,
        alc1.displayed_field status,
        ac.vendor_name supplier,
        to_number(pv.segment1) supplier_number,
        ac.vendor_site_code supplier_site,
        ac.void_date,
        pv.vendor_id,
        ac.check_id
FROM    ap_checks ac,
        fnd_user fu_cr,
        fnd_user fu_upd,
        ap_check_stocks acs,
        ap_lookup_codes alc,
        ap_lookup_codes alc1,
        ap_bank_accounts aba,
        po_vendors pv
WHERE   ac.check_stock_id = acs.check_stock_id(+)   
AND     ac.created_by = fu_cr.user_id   
AND     ac.last_updated_by = fu_upd.user_id   
AND     alc.lookup_type (+) = 'PAYMENT METHOD'   
AND     alc.lookup_code (+) = ac.payment_method_lookup_code   
AND     ac.external_bank_account_id = aba.bank_account_id(+)   
AND     alc1.lookup_type (+) = 'CHECK STATE'   
AND     alc1.lookup_code (+) = ac.status_lookup_code   
AND     ac.vendor_id = pv.vendor_id;
