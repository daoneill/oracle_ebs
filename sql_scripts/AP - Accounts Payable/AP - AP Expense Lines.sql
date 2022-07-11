SELECT  aerl.amount,
        aerl.attribute_category,
        TO_DATE(aerl.attribute1,'DD/MM/RRRR') start_date,
        TO_DATE(DECODE(aerl.attribute_Category,'Bicycle', aerl.attribute2,'Domestic Subsistence', aerl.attribute2,'Domestic Foreign Subsistence', aerl.attribute2,'Foreign Subsistence', aerl.attribute2,'Motor Cycle', aerl.attribute2,'Motor Travel', aerl.attribute3, 'Motor Travel Met Eireann', aerl.attribute3),'DD/MM/RRRR') end_date,
        DECODE(aerl.attribute_Category,'Motor Travel', aerl.attribute2, 'Motor Travel Met Eireann', aerl.attribute2) engine_size,
        DECODE(aerl.attribute_Category,'Bicycle', aerl.attribute3, 'Motor Cycle', aerl.attribute3, 'Motor Travel', aerl.attribute9, 'Motor Travel Met Eireann', aerl.attribute9) distance_Travelled_kms,
        DECODE(aerl.attribute_Category, 'Domestic Subsistence', aerl.attribute3, 'Domestic Foreign Subsistence', aerl.attribute3, 'Foreign Subsistence', aerl.attribute3) departure_time,
        DECODE(aerl.attribute_Category, 'Bicycle', aerl.attribute4, 'Motor Cycle', aerl.attribute4, 'Motor Travel', aerl.attribute8, 'Motor Travel Met Eireann', aerl.attribute8) local_kms,
        DECODE(aerl.attribute_Category,'Domestic Subsistence', aerl.attribute4, 'Domestic Foreign Subsistence', aerl.attribute4,'Foreign Subsistence', aerl.attribute4) return_time,
        DECODE(aerl.attribute_category, 'Motor Travel', aerl.attribute4) alternate_engine_size,
        DECODE(aerl.attribute_category, 'Domestic Subsistence', aerl.attribute5, 'Domestic Foreign Subsistence', aerl.attribute5, 'Foreign Subsistence', aerl.attribute6) subsistence_class,
        DECODE(aerl.attribute_category,'Foreign Subsistence', aerl.attribute5) destination,
        DECODE(aerl.attribute_category,'Motor Travel', aerl.attribute5) alternate_car_justification,
        DECODE(aerl.attribute_category, 'Motor Travel', aerl.attribute6, 'Motor Travel Met Eireann', aerl.attribute6, 'Domestic Subsistence', aerl.attribute7, 'Domestic Foreign Subsistence', aerl.attribute7) rate_type,
        DECODE(aerl.attribute_category, 'Foreign Subsistence',aerl.attribute7, 'Domestic Subsistence', aerl.attribute8, 'Domestic Foreign Subsistence', aerl.attribute8) alternate_class,
        DECODE(aerl.attribute_category, 'Motor Travel', aerl.attribute7, 'Motor Travel Met Eireann', aerl.attribute7) aa_official_distance,
        DECODE(aerl.attribute_category,'Foreign Subsistence', aerl.attribute8, 'Domestic Subsistence', aerl.attribute9, 'Domestic Foreign Subsistence', aerl.attribute9) alternate_class_justification,
        DECODE(aerl.attribute_category, 'Foreign Subsistence', aerl.attribute9) number_of_lunches_provided,
        DECODE(aerl.attribute_category,'Foreign Subsistence', aerl.attribute10, 'Domestic Subsistence', aerl.attribute12, 'Domestic Foreign Subsistence', aerl.attribute12) value_of_meals_accom_provided,
        DECODE(aerl.attribute_category, 'Motor Travel', aerl.attribute10, 'Motor Travel Met Eireann', aerl.attribute10) cum_kms_for_current_year,
        DECODE(aerl.attribute_category, 'Domestic Subsistence', aerl.attribute11, 'Domestic Foreign Subsistence', aerl.attribute11) H5_accounts_use_only,
        DECODE(aerl.attribute_category, 'Motor Travel', aerl.attribute11, 'Motor Travel Met Eireann', aerl.attribute11) to_be_included_in_cum_kms,
        DECODE(aerl.attribute_category, 'Foreign Subsistence', aerl.attribute11) is_airfare_refundable,
        DECODE(aerl.attribute_category, 'Foreign Subsistence', aerl.attribute12, 'Domestic Subsistence', aerl.attribute13, 'Domestic Foreign Subsistence', aerl.attribute13) conference_rate,
        DECODE(aerl.attribute_category, 'Foreign Subsistence', aerl.attribute13) travelling_with_minister,
        aerl.attribute14 ts_breakdown,
        aerl.attribute15 retrospection_flag,
        fu_cr.user_name created_by,
        aerl.creation_Date,
        aerl.currency_Code,
        aerl.distribution_line_number,
        xpp.full_name employee_name,
        gcc.segment1,
        SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,1,gcc.segment1),1,40) segment1_desc,
        gcc.segment2,
        SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,2,gcc.segment1),2,40) segment1_desc,
        gcc.segment3,
        SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,3,gcc.segment1),3,40) segment1_desc,
        gcc.segment4,
        SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,4,gcc.segment1),4,40) segment1_desc,
        gcc.segment5,
        SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,5,gcc.segment1),5,40) segment1_desc,
        gcc.segment6,
        SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,6,gcc.segment1),6,40) segment1_desc,
        gcc.segment7,
        SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,7,gcc.segment1),7,40) segment1_desc,
        gcc.segment8,
		SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,8,gcc.segment1),8,40) segment1_desc,
        gcc.segment9,
		SUBSTR(apps.gl_flexfields_pkg.get_description_sql( gcc.chart_of_accounts_id,9,gcc.segment1),9,40) segment1_desc,
        aerh.invoice_num,
        aerl.item_description,
        aerl.justification,
        aerl.last_update_date,
        fu_upd.user_name last_updated_by,
        aerl.receipt_Currency_code,
        DECODE(aerl.receipt_Required_flag,'Y','Yes','N','No') receipt_required_flag,
        DECODE(aerl.receipt_missing_flag,'Y','Yes','N','No') receipt_missing_flag,
        DECODE(aerl.receipt_Verified_flag,'Y','Yes','N','No') receipt_verified_flag,
        aerl.start_expense_date,
        aerl.end_expense_date,
        aerl.report_header_id,
        xpp.person_id
FROM    ap_Expense_report_lines             aerl,
        ap_expense_report_headers           aerh,
        fnd_user                            fu_cr,
        fnd_user                            fu_upd,
        per_people_x               			xpp,
        gl_code_combinations                gcc,
        ap_exp_report_dists                 aerd
WHERE   aerl.report_header_id = aerh.report_header_id
AND     aerl.report_line_id = aerd.report_line_id(+)
AND     aerh.employee_id = xpp.person_id(+)
AND     aerl.created_by = fu_cr.user_id(+)
AND     aerl.last_updated_by = fu_upd.user_id(+)
AND     aerd.code_combination_id = gcc.code_Combination_id(+)
AND     aerh.set_of_books_id = Fnd_Profile.value('GL_SET_OF_BKS_ID')