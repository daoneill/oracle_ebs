SELECT
    aps.creation_date                "Supplier Creation Date",
    assa.creation_date               "Site Creation Date",
    aps.last_update_date             "Supplier Last Update Date",
    assa.last_update_date            "Site Last Update Date",
    '** Supplier **',
    aps.vendor_name                  "Supplier",
    aps.segment1                     "Supplier Num",
    aps.vat_registration_num         "Supplier VAT Number",	
    aps.vendor_type_lookup_code             "Supplier Type", 	
    aps.pay_group_lookup_code               "Pay Group",	
    aps.hold_all_payments_flag              "Hold All Payments", 	
    aps.hold_future_payments_flag           "Hold Future Payments",	
    zptp.process_for_applicability_flag     "Tax - Allow Tax Applicability", 
    zptp.allow_offset_tax_flag              "Tax - Allow Offset Taxes",		        
    '** Supplier Site**',
    hou.name                         "Operating Unit",
    assa.vendor_site_code            "Site Name",
    assa.vat_registration_num        "Site VAT Number", 	
    assa.PAY_SITE_FLAG                      "Site Pay Flag", 	
    assa.PURCHASING_SITE_FLAG               "Site Purchasing Flag", 	
    assa.TAX_REPORTING_SITE_FLAG            "Site Tax Reporting Flag", 	
    assa.ATTRIBUTE5                         "MFGPro Site Number",	
    assa.ATTRIBUTE2                         "Oracle 11i Site Number", 	
    assa.INVOICE_CURRENCY_CODE              "Site Invoice Currency", 	
    assa.PAYMENT_CURRENCY_CODE              "Site Payment Currency", 	
    assa.MATCH_OPTION                       "Site Match Option",	
    assa.address_line1               "Site Address 1",
    assa.address_line2               "Site Address 2",
    assa.city                        "Site City",
    assa.zip                         "Site Zip",
    assa.country                     "Site Country",	
    assa.pay_group_lookup_code              "Site Pay Group",
    assa.fob_lookup_code                    "Site FOB", 
    assa.freight_terms_lookup_code          "Site Freight Terms",
    assa.country_of_origin_code             "Site COO", 
    (
        SELECT  LISTAGG(apt.name , ',') WITHIN GROUP (ORDER BY apt.name )
        FROM    apps.ap_terms_tl       apt
        WHERE   language = USERENV('LANG') 
        AND     term_id = assa.terms_id
    )                                       "Site Payment Terms",
    (
        SELECT
            LISTAGG(pv.payment_method_name, ',') WITHIN GROUP(
                ORDER BY
                    pv.payment_method_name
            )
        FROM
            apps.iby_external_payees_all    ip,
            apps.iby_ext_party_pmt_mthds    pm,
            apps.iby_payment_methods_vl     pv
        WHERE
                ip.supplier_site_id = assa.vendor_site_id
            AND ip.payee_party_id = aps.party_id
            AND ip.ext_payee_id = pm.ext_pmt_party_id
            AND pm.payment_method_code = pv.payment_method_code
    ) "Site Payment Methods",            
    gcck1.concatenated_segments             "Site Liability Acc",
    gcck2.concatenated_segments             "Site Prepayment Acc",
    iepa.remit_advice_email                 "Site Remit Email", 
    iepa.remit_advice_delivery_method       "Site Remit Delivery Mthd",
    iebv.bank_name                   "Bank Name",
    iebbv.bank_branch_name           "Branch Name",
    iebbv.branch_number              "Branch Number",
    iebbv.eft_swift_code             "EFT Swift Code",
    ieba.bank_account_num            "Bank Accout Num",
    ieba.bank_account_name           "Bank Account Name",
    ieba.iban                        "IBAN",
    ieba.country_code                "Bank Account Country",
    ieba.foreign_payment_use_flag    "Foreign Payment Flag",
    ieba.currency_code               "Bank Account Currency Code",
    ipiua.start_date                 "Bank Start Date",
    ipiua.end_date                   "Bank End Date"
FROM
    apps.ap_suppliers                aps,
    apps.ap_supplier_sites_all       assa,
    apps.hr_operating_units          hou,
    apps.gl_code_combinations_kfv    gcck1,
    apps.gl_code_combinations_kfv    gcck2,
    apps.iby_external_payees_all     iepa,
    apps.iby_pmt_instr_uses_all      ipiua,
    apps.iby_ext_bank_accounts       ieba,
    apps.iby_ext_bank_branches_v     iebbv,
    apps.iby_ext_banks_v             iebv,
    apps.zx_party_tax_profile        zptp
WHERE
        aps.vendor_id = assa.vendor_id
    AND hou.organization_id = assa.org_id
--AND     assa.org_id = 927
    AND gcck1.code_combination_id (+) = assa.accts_pay_code_combination_id
    AND gcck2.code_combination_id (+) = assa.prepay_code_combination_id
    AND assa.vendor_site_id = iepa.supplier_site_id (+)
    AND ipiua.ext_pmt_party_id (+) = iepa.ext_payee_id
    AND ipiua.instrument_type (+) = 'BANKACCOUNT'
    AND ipiua.payment_flow (+) = 'DISBURSEMENTS'
    AND ipiua.order_of_preference (+) = 1
    AND ipiua.instrument_id = ieba.ext_bank_account_id (+)
    AND iebbv.branch_party_id (+) = ieba.branch_id
    AND iebbv.bank_party_id (+) = ieba.bank_id
    AND iebv.bank_party_id (+) = ieba.bank_id
    AND aps.party_id = zptp.party_id (+)
    AND zptp.party_type_code (+) = 'THIRD_PARTY'
    AND aps.segment1 IN (
        '21770',
        '21184'
    )
    AND assa.vendor_site_code IN (
        'BIELSKO-BIALA',
        'UL. MIEDZYRZECK'
    )
ORDER BY
    aps.vendor_name,
    assa.vendor_site_code