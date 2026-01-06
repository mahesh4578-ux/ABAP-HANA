@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Cb'
@Metadata.ignorePropagatedAnnotations: true
@Analytics.dataCategory: #CUBE
define view entity ZI_UM_ORDER_CB as select from ZI_UM_ORDER
association[1] to ZI_UM_CUST_ENT as _Customer on
$projection.Buyer = _Customer.CustId
association[1] to ZI_UM_MAT_ENT  as _Product on
$projection.Product = _Product.MatId
{
key ZI_UM_ORDER.OrderId,
key ZI_UM_ORDER._items.item_id as ItemId,

ZI_UM_ORDER.OrderNo,
ZI_UM_ORDER.Buyer,
ZI_UM_ORDER.CreatedBy,
ZI_UM_ORDER.CreatedOn,
/* Associations */
ZI_UM_ORDER._items.product as Product,
@DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'CurrencyCode'
ZI_UM_ORDER._items.amount as GrossAmount,
ZI_UM_ORDER._items.currency as CurrencyCode,
@DefaultAggregation: #SUM
@Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
ZI_UM_ORDER._items.qty as Quantity,
ZI_UM_ORDER._items.uom as UnitOfMeasure,
_Product,
_Customer
}
