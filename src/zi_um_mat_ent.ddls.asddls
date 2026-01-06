@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product CDS View entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_UM_MAT_ENT as select from zum_btp_mattab
{
    key mat_id as MatId,
    name as Name,
    category as Category,
    @Semantics.amount.currencyCode: 'Currency'
    price as Price,
    currency as Currency,
    discount as Discount
}
