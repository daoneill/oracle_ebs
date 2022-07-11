WITH fnd_user_to_employee AS (
SELECT  fu.user_id, 
        ppx.person_id, 
        ppx.employee_number, 
        ppx.full_name
FROM    fnd_user        fu,
        per_people_x    ppx
WHERE   fu.employee_id = ppx.person_id
)
--
-- The following view will retrieve all AP Invoice Header information. 
--
SELECT  DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.invoice_id),
            'Y','Yes',
            'N','No',
            'P','Partial',
            'S','Selected'
        )                                               accounting_status,
        aia.amount_paid,
        alc_as.displayed_field                          approval_status,
        aia.attribute1                                  remittance_advice_turned_off,
        aia.attribute2                                  disputed_invoice,
        aia.attribute3                                  gss_extract_file,
        aia.attribute4,
        aia.attribute5,
        aia.attribute6,
        aia.attribute7,
        aia.attribute8,
        aia.attribute9,
        aia.attribute10,
        aia.attribute11,
        aia.attribute12,
        aia.attribute13,
        aia.attribute14,
        aia.attribute15,
        aia.cancelled_amount,
        xhpbv_ca.full_name                              cancelled_by,
        aia.cancelled_date                              cancelled_date,
        xhpbv_c.full_name                               created_by,
        aia.creation_date                               creation_date,
        aia.exchange_date                               exchange_date,
        aia.exchange_rate                               exchange_rate,
        aia.base_amount                                 functional_curr_amount,
        AP_INVOICES_UTILITY_PKG.GET_HOLDS_COUNT(
            aia.invoice_id
        )                                               active_hold_count, 
        aia.gl_date                                     gl_date,
        aia.invoice_amount                              invoice_amount,
        aia.invoice_currency_code                       invoice_currency_code,
        aia.invoice_date                                invoice_date,
        aia.invoice_received_date                       invoice_received_date,
        DECODE(aia.payment_Status_flag,
            'N','No',
            'P','Partial',
            'Yes'
        )                                               invoice_paid_flag,
        aia.description                                 invoice_description,
        aia.invoice_id                                  invoice_id,
        aia.invoice_num                                 invoice_number,
        aia.last_update_date                            last_update_date,
        xhpbv_l.full_name                               last_updated_by,
        aia.exclusive_payment_flag                      pay_alone_flag,
        aia.pay_group_lookup_code                       payment_group,
        alc_pm.displayed_field                          payment_method,
        aia.payment_cross_rate_type                     payment_rate_type,
        aia.payment_status_flag                         payment_status_flag,
        att.name                                        payment_terms,
        aia.terms_date                                  payment_terms_date,
        aia.payment_cross_rate_date                     payment_rate_date,
        aia.payment_cross_rate                          payment_rate,
        aia.payment_currency_code                       payment_currency,
        pv.vendor_name                                  supplier_name,
        pv.segment1                                     supplier_number,
        plc_st.displayed_field                          supplier_type,
        pvsa.vendor_site_code                           supplier_site, 
        aia.auto_tax_calc_flag,
        aia.vat_code                                    tax_code,
        aia.voucher_num                                 voucher_number,
        xhpbv_r.full_name                               requestor_name,
        aia.approval_ready_flag                         ready_for_approval,
        aba.batch_name                                  batch_name,
        aag.name                                        withholding_tax_group,
        AP_INVOICES_UTILITY_PKG.GET_AMOUNT_WITHHELD(
            aia.invoice_id
        )                                               withheld_amount,
        aia.org_id,
        AP_INVOICES_UTILITY_PKG.GET_PREPAID_AMOUNT(
            aia.invoice_id
        )                                               prepaid_amount,
        AP_INVOICES_UTILITY_PKG.GET_PO_NUMBER (
            aia.invoice_id
        )                                               po_number,
        pv.vendor_id                                    vendor_id,
        pvsa.vendor_site_id                             vendor_site_id
FROM    ap_invoices_all                                 aia,
        fnd_user_to_employee                      xhpbv_c,
        fnd_user_to_employee                      xhpbv_l,
        fnd_user_to_employee                      xhpbv_ca,
        fnd_user_to_employee                      xhpbv_r,
        ap_lookup_codes                                 alc_pm,
        ap_lookup_codes                                 alc_as,
        ap_terms_tl                                     att,
        po_vendors                                      pv,
        po_vendor_sites_all                             pvsa,
        po_lookup_codes                                 plc_st,
        ap_batches_all                                  aba,
        ap_awt_groups                                   aag
WHERE   aia.created_by = xhpbv_c.user_id(+)
AND     aia.last_updated_by = xhpbv_l.user_id(+)
AND     aia.cancelled_by = xhpbv_ca.person_id(+)
AND     aia.org_id = FND_PROFILE.VALUE('ORG_ID')
AND     alc_pm.lookup_type(+) = 'PAYMENT METHOD'
AND     alc_pm.lookup_code(+) = aia.payment_method_lookup_code
AND     alc_as.lookup_type(+) = 'AP_WFAPPROVAL_STATUS'
AND     alc_as.lookup_code(+) = aia.wfapproval_status
AND     aia.terms_id = att.term_id(+)
AND     aia.vendor_id = pv.vendor_id(+)
AND     aia.vendor_site_id = pvsa.vendor_site_id(+)
AND     aia.org_id = pvsa.org_id(+)
AND     plc_st.lookup_type(+) = 'VENDOR TYPE'
AND     plc_st.lookup_code(+) = pv.vendor_type_lookup_code
AND     aia.batch_id = aba.batch_id(+)
AND     aia.requester_id = xhpbv_r.person_id(+)
AND     aia.awt_group_id = aag.group_id(+);
