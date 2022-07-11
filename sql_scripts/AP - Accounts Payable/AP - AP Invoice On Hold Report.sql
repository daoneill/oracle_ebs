SELECT    DISTINCT haou.name organization,  
          aia.invoice_num,  
          aia.invoice_date, 
          pv.vendor_name supplier_name,  
          pv.segment1 supplier_num, 
          aha.hold_lookup_code, 
          aha.hold_reason, 
          aha.hold_date, 
          aia.invoice_currency_code, 
          aia.invoice_amount, 
          NVL(aia.doc_sequence_value, aia.voucher_num) voucher_num, 
          ( 
              SELECT    pha.segment1 
              FROM      apps.po_line_locations_all      plla,  
                        apps.po_headers_all             pha 
              WHERE     plla.po_header_id = pha.po_header_id 
              AND       plla.line_location_id = aha.line_location_id           
          ) po_number, 
          ( 
              SELECT    prha.segment1 
              FROM      apps.po_line_locations_all      plla,  
                        apps.po_headers_all             pha, 
                        apps.po_distributions_all       pda, 
                        apps.po_req_distributions_all   prda, 
                        apps.po_requisition_lines_all   prla, 
                        apps.po_requisition_headers_all prha 
              WHERE     plla.po_header_id = pha.po_header_id 
              AND       plla.line_location_id = aha.line_location_id  
              AND       plla.line_location_id = pda.line_location_id 
              AND       pda.req_distribution_id = prda.distribution_id 
              AND       prda.requisition_line_id = prla.requisition_line_id 
              AND       prla.requisition_header_id = prha.requisition_header_id       
              GROUP BY  prha.segment1   
          ) req_number, 
          ( 
              SELECT    papf.full_name 
              FROM      apps.po_line_locations_all      plla,  
                        apps.po_requisition_lines_all   prla, 
                        apps.po_requisition_headers_all prha, 
                        apps.per_all_people_f           papf 
              WHERE     plla.line_location_id = aha.line_location_id  
              AND       plla.line_location_id = prla.line_location_id 
              AND       prla.requisition_header_id = prha.requisition_header_id 
              AND       papf.person_id = prha.preparer_id 
              AND       SYSDATE BETWEEN papf.effective_start_date AND papf.effective_end_date      
              GROUP BY  papf.full_name 
          ) preparer, 
          ( 
              SELECT    papf.full_name 
              FROM      apps.po_line_locations_all      plla,  
                        apps.po_requisition_lines_all   prla, 
                        apps.po_requisition_headers_all prha, 
                        apps.per_all_people_f           papf 
              WHERE     plla.line_location_id = aha.line_location_id  
              AND       plla.line_location_id = prla.line_location_id 
              AND       prla.requisition_header_id = prha.requisition_header_id 
              AND       papf.person_id = prla.to_person_id 
              AND       SYSDATE BETWEEN papf.effective_start_date AND papf.effective_end_date      
              GROUP BY  papf.full_name 
          ) requester, 
          ( 
              SELECT    gcc.segment5 || ' - ' || ffvv.description 
              FROM      apps.po_line_locations_all      plla,  
                        apps.po_headers_all             pha, 
                        apps.po_distributions_all       pda, 
                        apps.gl_code_combinations       gcc, 
                        apps.fnd_flex_values_vl         ffvv 
              WHERE     plla.po_header_id = pha.po_header_id 
              AND       plla.line_location_id = aha.line_location_id     
              AND       pda.line_location_id = plla.line_location_id 
              AND       gcc.code_combination_id = pda.code_combination_id 
              AND       ffvv.flex_value_set_id = 1014931 
              AND       ffvv.flex_value = gcc.segment5   
              GROUP BY  gcc.segment5 || ' - ' || ffvv.description 
          ) area          
FROM      apps.ap_invoices_all                    aia, 
          apps.hr_all_organization_units          haou, 
          apps.po_vendors                         pv, 
          apps.ap_holds_all                       aha 
WHERE     aia.org_id = haou.organization_id 
AND       pv.vendor_id = aia.vendor_id 
AND       aia.invoice_id = aha.invoice_id 
AND       aha.release_lookup_code IS NULL 
AND       haou.name = 'IW' 
ORDER BY  haou.name, 
          aia.invoice_num
