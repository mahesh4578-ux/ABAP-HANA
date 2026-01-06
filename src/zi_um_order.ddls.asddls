@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_UM_ORDER as select from zum_btp_ord_h as hdr
association[1..*] to zum_btp_ord_i as _items on
$projection.OrderId = _items.order_id
{
   key order_id as OrderId,
   order_no as OrderNo,
   buyer as Buyer,
   created_by as CreatedBy,
   created_on as CreatedOn,
   _items
}
