SELECT  gl_sl_link_id, 
        source_table,
        source_id invoice_payment_id,
        aip.invoice_id,
        aip.check_id,
        NULL invoice_distribution_id,
        ai.invoice_num,
        ac.check_number
FROM    ap_ae_lines ael, 
        ap_invoice_payments aip, 
        ap_invoices ai, 
        ap_checks ac
WHERE   source_table = 'AP_INVOICE_PAYMENTS'
AND     ai.invoice_id = aip.invoice_id
AND     aip.check_id = ac.check_id
AND     ael.source_id = aip.invoice_payment_id
UNION ALL
SELECT  gl_sl_link_id, 
        source_table,
        NULL,
        source_id invoice_id,
        NULL,
        NULL invoice_distribution_id,
        ai.invoice_num,
        NULL
FROM    ap_ae_lines ael, 
        ap_invoices ai
WHERE   source_table = 'AP_INVOICES'
AND     ael.source_id = ai.invoice_id
UNION ALL
SELECT  gl_sl_link_id, 
        source_table,
        NULL,
        aid.invoice_id,
        NULL,
        aid.invoice_distribution_id,
        ai.invoice_num,
        NULL
FROM    ap_ae_lines ael, 
        ap_invoice_distributions aid, 
        ap_invoices ai
WHERE   source_table = 'AP_INVOICE_DISTRIBUTIONS'
AND     ael.source_id = aid.invoice_distribution_id
AND     ai.invoice_id = aid.invoice_id
UNION ALL
SELECT  gl_sl_link_id, 
        source_table,
        NULL,
        NULL,
        ac.check_id,
        NULL,
        NULL,
        ac.check_number
FROM    ap_ae_lines ael, 
          ap_checks ac
WHERE   source_table = 'AP_CHECKS'
AND     ael.source_id = ac.check_id;
