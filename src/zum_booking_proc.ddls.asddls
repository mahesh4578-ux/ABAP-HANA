@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Processor'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZUM_BOOKING_PROC as projection on ZUM_M_BOOKING
{
    key TravelId,
    key BookingId,
    BookingDate,
    
    @Consumption.valueHelpDefinition:[{
    entity.name: '/DMO/I_Customer',
    entity.element: 'CustomerID'
    }]
    CustomerId,
    @Consumption.valueHelpDefinition:[{
    entity.name: '/DMO/I_Carrier',
    entity.element: 'AirLineID'
    }]
    CarrierId,
    @Consumption.valueHelpDefinition:[{
    entity.name: '/DMO/I_Connection',
    entity.element: 'ConnectionID',
    additionalBinding: [{ localElement : 'CarrierId',
                          element : 'AirLineID'
                        }
                        ]
    }]
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
    @Consumption.valueHelpDefinition:[{
    entity.name: '/DMO/I_Booking_Status_VH',
    entity.element: 'BookingStatus'
    }]
    BookingStatus,
    LastChangedAt,
    
    /* Associations */
    _BookingStatus,
    _BookingSupplement : redirected to composition child ZUM_BOOKSUPPL_PROC,
    _Carrier,
    _Connection,
    _Customer,
    _Travel: redirected to parent ZUM_TRAVEL_PROC
}
