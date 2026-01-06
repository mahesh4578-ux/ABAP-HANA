@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking supplement processor'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZUM_BOOKSUPPL_PROC as projection on ZUM_M_BOOKSUPPL
{
   key TravelId,
   key BookingId,
   key BookingSupplementId,
   SupplementId,
   @Semantics.amount.currencyCode: 'CurrencyCode'
   Price,
   CurrencyCode,
   LastChangedAt,
   /* Associations */
   _Booking : redirected to ZUM_BOOKING_PROC,
  // _Product,
  // _SupplementText,
   _Travel 
}
