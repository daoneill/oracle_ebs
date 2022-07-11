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
-- The following view will retrieve all AP Invoice Hold information..
--
SELECT  aha.attribute1,
        aha.attribute2,
        aha.attribute3,
        aha.attribute4,
        aha.attribute5,
        aha.attribute6,
        aha.attribute7,
        aha.attribute8,
        aha.attribute9,
        aha.attribute10,
        aha.attribute11,
        aha.attribute12,
        aha.attribute13,
        aha.attribute14,
        aha.attribute15,
        xhpbv_c.full_name                               created_by,
        aha.creation_date                               creation_date,
        xhpbv_ho.full_name                              held_by,
        aha.hold_date                                   hold_date,
        ahc_hold.hold_lookup_code                       hold_name,
        ahc_hold.description                            hold_description,
        aha.hold_reason                                 hold_reason,
        aia.invoice_num                                 invoice_number,
        aha.last_update_date                            last_update_date,
        xhpbv_l.full_name                               last_updated_by,
        DECODE(
            aha.release_lookup_code, NULL, NULL, aha.last_update_date
        )                                               release_date,
        ahc_release.description                         release_description,
        ahc_release.hold_lookup_code                    release_name,
        aha.release_reason                              release_reason,
        DECODE(
            aha.release_lookup_code, NULL, NULL, xhpbv_l.full_name
        )                                               released_by,
        pv.vendor_name                                  supplier_name,
        pv.segment1                                     supplier_number,
        aia.invoice_id                                  invoice_id,
        aia.org_id                                      org_id
FROM    ap_holds_all                                    aha,
        ap_hold_codes                                   ahc_hold,
        ap_hold_codes                                   ahc_release,
        fnd_user_to_employee                            xhpbv_c,
        fnd_user_to_employee                            xhpbv_l,
        fnd_user_to_employee                            xhpbv_ho,
        po_vendors                                      pv,
        ap_invoices_all                                 aia
WHERE   aha.invoice_id = aia.invoice_id
AND     aha.org_id = aia.org_id
AND     aha.org_id = FND_PROFILE.VALUE('ORG_ID')
AND     aha.hold_lookup_code = ahc_hold.HOLD_LOOKUP_CODE
AND     aha.release_lookup_code = ahc_release.hold_lookup_code(+)
AND     aha.created_by = xhpbv_c.user_id(+)
AND     aha.last_updated_by = xhpbv_l.user_id(+)
AND     aha.held_by = xhpbv_ho.user_id(+)
AND     aia.vendor_id = pv.vendor_id;
