@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Processor'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZUM_BOOKING_PROC as projection on ZUM_M_BOOKING
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    
    /* Associations */
    _BookingStatus,
    _BookingSupplement,
    _Carrier,
    _Connection,
    _Customer,
    _Travel: redirected to ZUM_TRAVEL_PROC
}
