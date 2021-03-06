SELECT  aba.currency_code account_currency,
        aisc.attribute1,
        aisc.attribute2,
        aisc.attribute3,
        aisc.attribute4,
        aisc.attribute5,
        aisc.attribute6,
        aisc.attribute7,
        aisc.attribute8,
        aisc.attribute9,
        aisc.attribute10,
        aisc.attribute11,
        aisc.attribute12,
        aisc.attribute13,
        aisc.attribute14,
        aisc.attribute15,
        aba.bank_account_name internal_bank_account_name,
        aba.bank_account_num internal_bank_Account_num,
        aisc.checkrun_name batch_name,
        DECODE(aisc.status,
            'BUILDING', Ap_Inv_Selection_Criteria_Pkg.get_pre_conf_paymt_total(aisc.checkrun_name),
            'BUILT', Ap_Inv_Selection_Criteria_Pkg.get_pre_conf_paymt_total(aisc.checkrun_name),
            'FORMATTING', Ap_Inv_Selection_Criteria_Pkg.get_pre_conf_paymt_total(aisc.checkrun_name),
            'FORMATTED', Ap_Inv_Selection_Criteria_Pkg.get_pre_conf_paymt_total(aisc.checkrun_name),
            'CONFIRMED',  Ap_Inv_Selection_Criteria_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'CANCELING', Ap_Inv_Selection_Criteria_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'CANCELED', Ap_Inv_Selection_Criteria_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'QUICKCHECK',  Ap_Inv_Selection_Criteria_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'REBUILDING', Ap_Inv_Selection_Criteria_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'RESTARTING',  Ap_Inv_Selection_Criteria_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
        NULL) current_batch_total ,
        DECODE(aisc.status,
            'BUILDING', Ap_Inv_Selection_Criteria_Pkg.get_pre_conf_paymt_total(aisc.checkrun_name),
            'BUILT', Ap_Inv_Selection_Criteria_Pkg.get_pre_conf_paymt_total(aisc.checkrun_name),
            'FORMATTING', Ap_Inv_Selection_Criteria_Pkg.get_pre_conf_paymt_total(aisc.checkrun_name),
            'FORMATTED', Ap_Inv_Selection_Criteria_Pkg.get_pre_conf_paymt_total(aisc.checkrun_name),
            'CONFIRMED',  Xxdoehlg_Discoverer_Misc_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'CANCELING', Xxdoehlg_Discoverer_Misc_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'CANCELED', Xxdoehlg_Discoverer_Misc_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'QUICKCHECK',  Xxdoehlg_Discoverer_Misc_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'REBUILDING', Xxdoehlg_Discoverer_Misc_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
            'RESTARTING', Xxdoehlg_Discoverer_Misc_Pkg.get_post_conf_paymt_total(aisc.checkrun_name),
        NULL) original_batch_total ,
        fu_cr.user_name created_by,
        aisc.creation_date,
        aisc.exchange_date,
        aisc.exchange_rate_type,
        aisc.start_print_document first_document,
        aisc.end_print_document last_document,
        aisc.last_update_date,
        fu_upd.user_name last_updated_by,
        DECODE(AISC.STATUS,
            'UNSTARTED',   'Select Invoices',
            'BUILDING',  'Build',
            'BUILT',  'Format',
            'CANCELED',  'None',
            'CANCELING',  'None',
            'CONFIRMED',  'Remittance Advice',
            'CONFIRMING',  'Confirm',
            'FORMATTED',  'Confirm',
            'FORMATTING',  'Format',
            'MODIFYING',  'Build',
            'QUICKCHECK',  'None',
            'REBUILDING',  'Build',
            'RESTARTING',  'Build',
            'SELECTED',  'Build',
            'SELECTING',  'Select Invoices',
        NULL) next_step,
        aisc.pay_thru_date,
        aisc.currency_code payment_currency,
        aisc.check_date payment_date,
        acs.name payment_document,
        aisc.vendor_pay_group payment_group,
        alc.displayed_field payment_method,
        alc1.displayed_field status
FROM    ap_invoice_selection_criteria aisc,
        ap_bank_accounts aba,
        ap_check_stocks acs,
        fnd_user fu_cr,
        fnd_user fu_upd,
        ap_lookup_codes alc,
        ap_lookup_codes alc1
WHERE   aisc.check_stock_id = acs.check_Stock_id(+)
AND     aisc.bank_Account_id = aba.bank_account_id(+)
AND     aisc.created_by = fu_cr.user_id
AND     aisc.last_updated_by = fu_upd.user_id
AND     alc.lookup_type (+) = 'PAYMENT METHOD'
AND     alc.lookup_code (+) = aisc.payment_method_lookup_code
AND     alc1.lookup_type(+) = 'CHECK BATCH STATUS'
AND     alc1.lookup_code(+) = aisc.status;
