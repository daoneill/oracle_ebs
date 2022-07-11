DECLARE

	--current_calling_sequence   varchar2 (2000) := 'AP_INVOICES_PKG.UPDATE_ROW -->';
	v_Pay_Group_Lookup_Code VARCHAR2(200) := 'PAY GROUP';  -- Pay Group to be updated on Invoice
	v_User_Name    VARCHAR2(200) := 'FIRST LAST'; -- User name which will be used to update the invoice
	v_Resp_Name    VARCHAR2(200) := 'AP Super User'; -- responsibility
	v_User_Id      NUMBER;
	v_Resp_Id      NUMBER;
	v_Resp_Appl_Id NUMBER;

	v_Check_Flag VARCHAR2(1);

	--Criteria to get the invoices for update
	CURSOR Cur_Pay_Group_Upd IS
		SELECT l.ROWID
				,l.*
		FROM   Ap_Invoices_All l
		WHERE  1 = 1
		AND    Invoice_Num IN ('123456') -- comment this condition to run the script for all invoices.
		AND    org_id = 111
		AND    Pay_Group_Lookup_Code <> 'EXISTING PAY GROUP'
		AND    SOURCE = 'CONVERSION';

BEGIN

	SELECT User_Id
	INTO   v_User_Id
	FROM   Fnd_User
	WHERE  User_Name = v_User_Name;

	SELECT Responsibility_Id
				,Application_Id
	INTO   v_Resp_Id
				,v_Resp_Appl_Id
	FROM   Fnd_Responsibility_Vl
	WHERE  Responsibility_Name = v_Resp_Name;

	Fnd_Global.Apps_Initialize(User_Id => v_User_Id, Resp_Id => v_Resp_Id, Resp_Appl_Id => v_Resp_Appl_Id);

	Mo_Global.Set_Policy_Context('S', 123);

	FOR Rec IN Cur_Pay_Group_Upd
	LOOP
		
      AP_INVOICES_PKG.Update_Row (
                      X_Rowid  =>  rec.Rowid,
                      X_Invoice_Id  =>  rec.Invoice_Id,
                      X_Last_Update_Date  =>  SYSDATE,--rec.Last_Update_Date,
                      X_Last_Updated_By  =>  v_User_Id,--rec.Last_Updated_By,
                      X_Vendor_Id  =>  rec.Vendor_Id,
                      X_Invoice_Num  =>  rec.Invoice_Num,
                      X_Invoice_Amount  =>  rec.Invoice_Amount,
                      X_Vendor_Site_Id  =>  rec.Vendor_Site_Id,
                      X_Amount_Paid  =>  rec.Amount_Paid,
                      X_Discount_Amount_Taken  =>  rec.Discount_Amount_Taken,
                      X_Invoice_Date  =>  rec.Invoice_Date,
                      X_Source  =>  rec.Source,
                      X_Invoice_Type_Lookup_Code  =>  rec.Invoice_Type_Lookup_Code,
                      X_Description  =>  rec.Description,
                      X_Batch_Id  =>  rec.Batch_Id,
                      X_Amt_Applicable_To_Discount  =>  rec.Amount_Applicable_To_Discount,
                      X_Terms_Id  =>  rec.Terms_Id,
                      X_Terms_Date  =>  rec.Terms_Date,
                      X_Goods_Received_Date  =>  rec.Goods_Received_Date,
                      X_Invoice_Received_Date  =>  rec.Invoice_Received_Date,
                      X_Voucher_Num  =>  rec.Voucher_Num,
                      X_Approved_Amount  =>  rec.Approved_Amount,
                      X_Approval_Status  =>  rec.Approval_Status,
                      X_Approval_Description  =>  rec.Approval_Description,
                      X_Pay_Group_Lookup_Code  =>  v_Pay_Group_Lookup_Code,--rec.Pay_Group_Lookup_Code,
                      X_Set_Of_Books_Id  =>  rec.Set_Of_Books_Id,
                      X_Accts_Pay_CCId  =>  rec.ACCTS_PAY_CODE_COMBINATION_ID,
                      X_Recurring_Payment_Id  =>  rec.Recurring_Payment_Id,
                      X_Invoice_Currency_Code  =>  rec.Invoice_Currency_Code,
                      X_Payment_Currency_Code  =>  rec.Payment_Currency_Code,
                      X_Exchange_Rate  =>  rec.Exchange_Rate,
                      X_Payment_Amount_Total  =>  rec.Payment_Amount_Total,
                      X_Payment_Status_Flag  =>  rec.Payment_Status_Flag,
                      X_Posting_Status  =>  rec.Posting_Status,
                      X_Authorized_By  =>  rec.Authorized_By,
                      X_Attribute_Category  =>  rec.Attribute_Category,
                      X_Attribute1  =>  rec.Attribute1,
                      X_Attribute2  =>  rec.Attribute2,
                      X_Attribute3  =>  rec.Attribute3,
                      X_Attribute4  =>  rec.Attribute4,
                      X_Attribute5  =>  rec.Attribute5,
                      X_Vendor_Prepay_Amount  =>  rec.Vendor_Prepay_Amount,
                      X_Base_Amount  =>  rec.Base_Amount,
                      X_Exchange_Rate_Type  =>  rec.Exchange_Rate_Type,
                      X_Exchange_Date  =>  rec.Exchange_Date,
                      X_Payment_Cross_Rate  =>  rec.Payment_Cross_Rate,
                      X_Payment_Cross_Rate_Type  =>  rec.Payment_Cross_Rate_Type,
                      X_Payment_Cross_Rate_Date  =>  rec.Payment_Cross_Rate_Date,
                      X_Pay_Curr_Invoice_Amount  =>  rec.Pay_Curr_Invoice_Amount,
                      X_Last_Update_Login  =>  rec.Last_Update_Login,
                      X_Original_Prepayment_Amount  =>  rec.Original_Prepayment_Amount,
                      X_Earliest_Settlement_Date  =>  rec.Earliest_Settlement_Date,
                      X_Attribute11  =>  rec.Attribute11,
                      X_Attribute12  =>  rec.Attribute12,
                      X_Attribute13  =>  rec.Attribute13,
                      X_Attribute14  =>  rec.Attribute14,
                      X_Attribute6  =>  rec.Attribute6,
                      X_Attribute7  =>  rec.Attribute7,
                      X_Attribute8  =>  rec.Attribute8,
                      X_Attribute9  =>  rec.Attribute9,
                      X_Attribute10  =>  rec.Attribute10,
                      X_Attribute15  =>  rec.Attribute15,
                      X_Cancelled_Date  =>  rec.Cancelled_Date,
                      X_Cancelled_By  =>  rec.Cancelled_By,
                      X_Cancelled_Amount  =>  rec.Cancelled_Amount,
                      X_Temp_Cancelled_Amount  =>  rec.Temp_Cancelled_Amount,
                      X_Exclusive_Payment_Flag  =>  rec.Exclusive_Payment_Flag,
                      X_Po_Header_Id  =>  rec.Po_Header_Id,
                      X_Doc_Sequence_Id  =>  rec.Doc_Sequence_Id,
                      X_Doc_Sequence_Value  =>  rec.Doc_Sequence_Value,
                      X_Doc_Category_Code  =>  rec.Doc_Category_Code,
                      X_Expenditure_Item_Date  =>  rec.Expenditure_Item_Date,
                      X_Expenditure_Organization_Id  =>  rec.Expenditure_Organization_Id,
                      X_Expenditure_Type  =>  rec.Expenditure_Type,
                      X_Pa_Default_Dist_Ccid  =>  rec.Pa_Default_Dist_Ccid,
                      X_Pa_Quantity  =>  rec.Pa_Quantity,
                      X_Project_Id  =>  rec.Project_Id,
                      X_Task_Id  =>  rec.Task_Id,
                      X_Awt_Flag  =>  rec.Awt_Flag,
                      X_Awt_Group_Id  =>  rec.Awt_Group_Id,
                      X_Pay_Awt_Group_Id  =>  rec.Pay_Awt_Group_Id,
                      X_Reference_1  =>  rec.Reference_1,
                      X_Reference_2  =>  rec.Reference_2,
                      X_Org_Id  =>  rec.Org_Id,
                      X_global_attribute_category  =>  rec.global_attribute_category,
                      X_global_attribute1  =>  rec.global_attribute1,
                      X_global_attribute2  =>  rec.global_attribute2,
                      X_global_attribute3  =>  rec.global_attribute3,
                      X_global_attribute4  =>  rec.global_attribute4,
                      X_global_attribute5  =>  rec.global_attribute5,
                      X_global_attribute6  =>  rec.global_attribute6,
                      X_global_attribute7  =>  rec.global_attribute7,
                      X_global_attribute8  =>  rec.global_attribute8,
                      X_global_attribute9  =>  rec.global_attribute9,
                      X_global_attribute10  =>  rec.global_attribute10,
                      X_global_attribute11  =>  rec.global_attribute11,
                      X_global_attribute12  =>  rec.global_attribute12,
                      X_global_attribute13  =>  rec.global_attribute13,
                      X_global_attribute14  =>  rec.global_attribute14,
                      X_global_attribute15  =>  rec.global_attribute15,
                      X_global_attribute16  =>  rec.global_attribute16,
                      X_global_attribute17  =>  rec.global_attribute17,
                      X_global_attribute18  =>  rec.global_attribute18,
                      X_global_attribute19  =>  rec.global_attribute19,
                      X_global_attribute20  =>  rec.global_attribute20,
                      X_calling_sequence  =>  NULL,--rec.calling_sequence,
                      X_gl_date  =>  rec.gl_date,
                      X_award_Id  =>  rec.award_Id,
                      X_approval_iteration  =>  rec.approval_iteration,
                      X_approval_ready_flag  =>  rec.approval_ready_flag,
                      X_wfapproval_status  =>  rec.wfapproval_status,
                      X_requester_id  =>  rec.requester_id,
                      X_quick_credit  =>  rec.quick_credit,
                      X_credited_invoice_id  =>  rec.credited_invoice_id,
                      X_distribution_set_id  =>  rec.distribution_set_id,
                      X_FORCE_REVALIDATION_FLAG  =>  rec.FORCE_REVALIDATION_FLAG,
                      X_CONTROL_AMOUNT  =>  rec.CONTROL_AMOUNT,
                      X_TAX_RELATED_INVOICE_ID  =>  rec.TAX_RELATED_INVOICE_ID,
                      X_TRX_BUSINESS_CATEGORY  =>  rec.TRX_BUSINESS_CATEGORY,
                      X_USER_DEFINED_FISC_CLASS  =>  rec.USER_DEFINED_FISC_CLASS,
                      X_TAXATION_COUNTRY  =>  rec.TAXATION_COUNTRY,
                      X_DOCUMENT_SUB_TYPE  =>  rec.DOCUMENT_SUB_TYPE,
                      X_SUPPLIER_TAX_INVOICE_NUMBER  =>  rec.SUPPLIER_TAX_INVOICE_NUMBER,
                      X_SUPPLIER_TAX_INVOICE_DATE  =>  rec.SUPPLIER_TAX_INVOICE_DATE,
                      X_SUPPLIER_TAX_EXCHANGE_RATE  =>  rec.SUPPLIER_TAX_EXCHANGE_RATE,
                      X_TAX_INVOICE_RECORDING_DATE  =>  rec.TAX_INVOICE_RECORDING_DATE,
                      X_TAX_INVOICE_INTERNAL_SEQ  =>  rec.TAX_INVOICE_INTERNAL_SEQ,
                      X_QUICK_PO_HEADER_ID  =>  rec.QUICK_PO_HEADER_ID,
                      x_PAYMENT_METHOD_CODE  =>  rec.PAYMENT_METHOD_CODE,
                      x_PAYMENT_REASON_CODE  =>  rec.PAYMENT_REASON_CODE,
                      X_PAYMENT_REASON_COMMENTS  =>  rec.PAYMENT_REASON_COMMENTS,
                      x_UNIQUE_REMITTANCE_IDENTIFIER  =>  rec.UNIQUE_REMITTANCE_IDENTIFIER,
                      x_URI_CHECK_DIGIT  =>  rec.URI_CHECK_DIGIT,
                      x_BANK_CHARGE_BEARER  =>  rec.BANK_CHARGE_BEARER,
                      x_DELIVERY_CHANNEL_CODE  =>  rec.DELIVERY_CHANNEL_CODE,
                      x_SETTLEMENT_PRIORITY  =>  rec.SETTLEMENT_PRIORITY,
                      x_NET_OF_RETAINAGE_FLAG  =>  rec.NET_OF_RETAINAGE_FLAG,
                      x_RELEASE_AMOUNT_NET_OF_TAX  =>  rec.RELEASE_AMOUNT_NET_OF_TAX,
                      x_PORT_OF_ENTRY_CODE  =>  rec.PORT_OF_ENTRY_CODE,
                      x_external_bank_account_id  =>  rec.external_bank_account_id,
                      x_party_id  =>  rec.party_id,
                      x_party_site_id  =>  rec.party_site_id,
                      x_disc_is_inv_less_tax_flag  =>  rec.disc_is_inv_less_tax_flag,
                      x_exclude_freight_from_disc  =>  rec.exclude_freight_from_discount,
                      x_remit_msg1  =>  rec.REMITTANCE_MESSAGE1,
                      x_remit_msg2  =>  rec.REMITTANCE_MESSAGE2,
                      x_remit_msg3  =>  rec.REMITTANCE_MESSAGE3,
                      x_remit_to_supplier_name  =>  rec.remit_to_supplier_name,
                      x_remit_to_supplier_id  =>  rec.remit_to_supplier_id,
                      x_remit_to_supplier_site  =>  rec.remit_to_supplier_site,
                      x_remit_to_supplier_site_id  =>  rec.remit_to_supplier_site_id,
                      x_relationship_id  =>  rec.relationship_id,
                      x_original_invoice_amount  =>  rec.original_invoice_amount,
                      x_dispute_reason  =>  rec.dispute_reason
      );

    
		COMMIT;
	
		SELECT Decode(COUNT(1), 0, 'N', 'Y')
		INTO   v_Check_Flag
		FROM   Apps.Ap_Invoices_All
		WHERE  1=1
    AND Invoice_Id = rec.Invoice_Id
    AND pay_group_lookup_code  = v_pay_group_lookup_code
    ;
	
		Dbms_Output.Put_Line('Pay Group Code updated for ' || rec.Invoice_Num || ' {Y/N} : ' || v_Check_Flag );
	END LOOP;
END;
/