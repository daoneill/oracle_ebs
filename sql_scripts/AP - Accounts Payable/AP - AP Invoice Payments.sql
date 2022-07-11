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
-- The following view will retrieve all AP Invoice Payment information..
-- 
SELECT  aip.attribute1, 
        aip.attribute2, 
        aip.attribute3, 
        aip.attribute4,
        aip.attribute5, 
        aip.attribute6, 
        aip.attribute7, 
        aip.attribute8,
        aip.attribute9, 
        aip.attribute10, 
        aip.attribute11, 
        aip.attribute12,
        aip.attribute13, 
        aip.attribute14, 
        aip.attribute15,
        ac.checkrun_name      batch_name, 
        ac.check_date         payment_date,
        ac.check_number       check_number, 
        fu_cr.full_name       created_by,
        aip.creation_date     creation_date, 
        aip.accounting_date   gl_date, 
        aia.invoice_amount    invoice_amount,
        aia.description       invoice_description, 
        aia.invoice_num       invoice_number,
        aip.last_update_date  last_update_date, 
        fu_upd.full_name      last_updated_by,
        aip.amount            payment_amount, 
        pv.vendor_name        supplier_name,
        pv.segment1           supplier_number,
        alc.displayed_field   payment_method,
        ac.void_date          void_date, 
        aia.invoice_id        invoice_id,
        ac.check_id           check_id, 
        pv.vendor_id          vendor_id, 
        aip.invoice_payment_id invoice_payment_id,
        aia.vendor_site_id     vendor_site_id,
        pvs.vendor_site_code   supplier_site,
        aip.org_id             org_id
FROM    ap_invoice_payments_all                                               aip,
        ap_checks_all                                                         ac,
        ap_invoices_all                                                       aia,
        po_vendors                                                            pv,
        fnd_user_to_employee                                         		 fu_cr,
        fnd_user_to_employee                                         		 fu_upd,
        ap_lookup_codes                                                       alc,
        po_vendor_sites_all                                                   pvs
WHERE   aip.check_id = ac.check_id
AND     aip.invoice_id = aia.invoice_id
AND     aia.vendor_id = pv.vendor_id
AND     alc.lookup_type(+) = 'PAYMENT METHOD'
AND     alc.lookup_code(+) = ac.payment_method_lookup_code
AND     aip.created_by = fu_cr.user_id(+)
AND     aip.last_updated_by = fu_upd.user_id(+)
AND     aia.org_id = FND_PROFILE.VALUE('ORG_ID')
AND     aip.org_id = aia.org_id
AND     ac.org_id = aia.org_id
AND     aia.vendor_site_id = pvs.vendor_site_id(+);
