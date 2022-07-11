SELECT  aiah.amount_approved,
        aiah.iteration approval_sequence,
        DECODE(NVL(aiah.response,'X'),'X',NULL, aiah.last_update_date) approved_date,
        aiah.approver_name approver,
        aiah.approver_comments,
        fu_cr.user_name created_by,
        aiah.creation_date,
        ai.invoice_num invoice_number,
        ai.invoice_id invoice_id,
        aiah.last_update_date,
        fu_upd.user_name last_updated_by,
        alc.displayed_field response,
        pv.vendor_name supplier_name,
        TO_NUMBER(pv.segment1) supplier_number,
        aiah.approval_history_id,
        pv.vendor_id
FROM    ap_inv_aprvl_hist aiah,
        ap_invoices ai,
        fnd_user fu_cr,
        fnd_user fu_upd,
        po_vendors pv,
        ap_lookup_codes alc
WHERE   aiah.invoice_id = ai.invoice_id
AND     alc.lookup_code(+)=aiah.response
AND     alc.lookup_type(+) = 'AP_WFAPPROVAL_STATUS'
AND     aiah.created_by = fu_cr.user_id
AND     aiah.last_updated_by = fu_upd.user_id
AND     ai.vendor_id = pv.vendor_id;
