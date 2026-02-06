@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Analytics'
@Metadata.ignorePropagatedAnnotations: true
//@Analytics.query: true
define view entity ZC_UM_ORDER_ANT as select from ZI_UM_ORDER_CB
{
 //@AnalyticsDetails.query.axis  : #ROWS
 key _Customer.CompanyName,
// @AnalyticsDetails.query.axis  : #ROWS
 key _Customer.CountryName,
 //@Aggregation.default: #SUM
 @Semantics.amount.currencyCode: 'CurrencyCode'
 //@AnalyticsDetails.query.axis  : #COLUMNS
 GrossAmount,
 //@AnalyticsDetails.query.axis  : #ROWS
 //@Consumption.filter.selectionType: #SINGLE
 CurrencyCode,
 @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
 //@AnalyticsDetails.query.axis  : #COLUMNS
 Quantity,
 //@AnalyticsDetails.query.axis  : #ROWS
 UnitOfMeasure
   
   
} 
