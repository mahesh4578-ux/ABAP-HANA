@EndUserText.label: 'Table functions - Total sales'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_ALLOWED
define table function ZUM_BTP_CDS_TFUNC
//with parameters 
//@Environment.systemField: #CLIENT
//p_clnt : abap.clnt
returns {
 
  client : abap.clnt;
  company_name : abap.char(256);
  total_sales : abap.curr(15,2);
  currency_code : abap.cuky(5);
  customer_rank : abap.int4;
  
}
implemented by method zcl_um_amdp=>get_total_sales;