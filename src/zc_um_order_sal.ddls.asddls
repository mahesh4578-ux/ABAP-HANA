@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'order sales'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_UM_ORDER_SAL 
as select from ZUM_BTP_CDS_TFUNC as ranked
inner join zum_btp_custtab as cust on
ranked.company_name = cust.company_name
{
key 
    ranked.company_name,
    @Semantics.amount.currencyCode: 'currency_code'
    ranked.total_sales,
    ranked.currency_code,
    ranked.customer_rank,
    cust.country
}
