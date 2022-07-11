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
-- The following view will retrieve all AP Invoice Distribution information.
--
SELECT  DECODE(aida.posted_flag,
            'Y','Yes',
            'N','No',
            'P','Partial'
        )                                           accounting_status,
        DECODE(aida.accrual_posted_flag,
            'Y','Yes',
            'N','No',
            'P','Partial'
        )                                           accrual_posted_flag,
        aida.amount                                 amount,
        aida.attribute1                             attribute1,
        aida.attribute2                             attribute2,
        aida.attribute3                             attribute3,
        aida.attribute4                             attribute4,
        aida.attribute5                             attribute5,
        aida.attribute6                             attribute6,
        aida.attribute7                             attribute7,
        aida.attribute8                             attribute8,
        aida.attribute9                             attribute9,
        aida.attribute10                            attribute10,
        aida.attribute11                            attribute11,
        aida.attribute12                            attribute12,
        aida.attribute13                            attribute13,
        aida.attribute14                            attribute14,
        aida.attribute15                            attribute15,
        aida.attribute_category                     attribute_context,
        DECODE(aida.cash_posted_flag,
            'Y','Yes',
            'N','No',
            'P','Partial'
        )                                           cash_posted_flag,
        xhpbv_c.full_name                           created_by,
        aida.creation_date                          creation_date,
        aida.description                            description,
        gcck.concatenated_segments                  distribution_account,
        DECODE(NVL(aida.encumbered_flag,'N'),
            'Y','Yes',
            'N','No'
        )                                           encumbered_flag,
        aida.accounting_date                        gl_date,
        DECODE(aida.amount_includes_tax_flag,
            'Y','Yes',
            'N','No'
        )                                           includes_tax_flag,
        aia.invoice_num                             invoice_number,
        aia.invoice_id                              invoice_id,
        aida.org_id                                 org_id,
        DECODE(aida.match_status_flag,
            'A','Validated','T',
            'Requires Revalidation','N', 
            'Requires Revalidation',
            'Never Validated'
        )                                           invoice_distribution_status,
        aida.last_update_date                       last_update_date,
        xhpbv_l.full_name                           last_updated_by,
        aida.line_type_lookup_code                  line_type,
        aida.distribution_line_number               line_number,
        DECODE(aida.final_match_flag,
            'Y','Yes',
            'N','No'
        )                                           final_match_status,
        aida.po_distribution_id                     po_distribution_id,
        aida.reversal_flag                          reversal_flag,
        aida.tax_recoverable_flag                   recoverable_flag,
        atca.name                                   tax_code,
        aida.assets_tracking_flag                   track_as_asset_flag,
        aag.name                                    withholding_tax_group
FROM    ap_invoice_distributions_all                aida,
        fnd_user_to_employee                  xhpbv_c,
        fnd_user_to_employee                  xhpbv_l,
        gl_code_combinations_kfv                    gcck,
        ap_invoices_all                             aia,
        ap_awt_groups                               aag,
        ap_tax_codes_all                            atca
WHERE   aida.org_id = FND_PROFILE.VALUE('ORG_ID')
AND     aida.created_by = xhpbv_c.user_id(+)
AND     aida.last_updated_by = xhpbv_l.user_id(+)
AND     aida.dist_code_combination_id = gcck.code_combination_id(+)
AND     aia.invoice_id = aida.invoice_id
AND     aia.org_id = aida.org_id
AND     aida.awt_group_id = aag.group_id(+)
AND     aida.tax_code_id = atca.tax_id(+);
