@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking supplement as child entity'

define view entity ZUM_M_BOOKSUPPL as select from /dmo/booksuppl_m
//association to parent target_data_source_name as _association_name
//    on $projection.element_name = _association_name.target_element_name
association to parent ZUM_M_BOOKING as _Booking on
 $projection.TravelId = _Booking.TravelId and
$projection.BookingId = _Booking.BookingId
association[1..1] to ZUM_M_TRAVEL as _Travel on
 $projection.TravelId = _Travel.TravelId
association[1..1] to /DMO/I_Supplement as _Product on
 $projection.BookingSupplementId = _Product.SupplementID
association[1..*] to /DMO/I_SupplementText as _SupplementText on
 $projection.SupplementId = _SupplementText.SupplementID
{
   key travel_id as TravelId,
   key booking_id as BookingId,
   key booking_supplement_id as BookingSupplementId,
   supplement_id as SupplementId,
   @Semantics.amount.currencyCode: 'CurrencyCode'
   price as Price,
   currency_code as CurrencyCode,
   @Semantics.systemDateTime.lastChangedAt: true
   last_changed_at as LastChangedAt ,
//    _association_name // Make association public
    _Travel,
    _Product,
    _SupplementText,
    _Booking
}
