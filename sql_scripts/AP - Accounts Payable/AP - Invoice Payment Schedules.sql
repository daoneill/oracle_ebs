SELECT  aps.attribute1,
        aps.attribute2,
        aps.attribute3,
        aps.attribute4,
        aps.attribute5,
        aps.attribute6,
        aps.attribute7,
        aps.attribute8,
        aps.attribute9,
        ai.invoice_num invoice_number,
        aba.bank_account_name paid_to_account,
        aps.due_date payment_due_date,
        DECODE(aps.payment_status_flag,'Y','Yes','N','No','P','Partial') payment_status,
        alc1.displayed_field payment_method,
        pv.vendor_name supplier_name,
        pvs.vendor_site_code supplier_site,
        aps.creation_date,
        fu_cr.user_name created_by,
        aps.last_update_date,
        fu_upd.user_name last_updated_by,
        ai.invoice_id,
        pv.vendor_id,
        pvs.vendor_site_id,
        aba.bank_account_id,
        aba.bank_branch_id
FROM    ap_lookup_codes alc1,
        ap_payment_Schedules aps,
        ap_invoices ai,
        fnd_user fu_cr,
        fnd_user fu_upd,
        ap_bank_Accounts aba,
        po_vendors pv,
        po_vendor_sites pvs
WHERE   aps.invoice_id = ai.invoice_id
AND     alc1.lookup_code (+) = aps.payment_method_lookup_code
AND     alc1.lookup_type (+) = 'PAYMENT METHOD'
AND     aps.created_by = fu_cr.user_id
AND     aps.last_updated_by = fu_upd.user_id
AND     aba.bank_account_id(+) = aps.external_bank_account_id
AND     ai.vendor_id = pv.vendor_id
AND     ai.vendor_site_id = pvs.vendor_site_id;
