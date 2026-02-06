@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Processor'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZUM_TRAVEL_PROC as projection on ZUM_M_TRAVEL
{
    @ObjectModel.text.element: ['Description']
    key TravelId,
    @ObjectModel.text.element: ['AgencyName']
    @Consumption.valueHelpDefinition:[{
    entity.name: '/DMO/I_Agency',
    entity.element: 'AgencyID'
    }]
    AgencyId,
    @Semantics.text: true
    _Agency.Name as AgencyName,

    @ObjectModel.text.element: ['CustomerName']
    @Consumption.valueHelpDefinition:[{
    entity.name: '/DMO/I_Customer',
    entity.element: 'CustomerID'
    }]
    CustomerId,
    @Semantics.text: true
    _Customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element: [ 'StatusText' ]
    @Consumption.valueHelpDefinition:[{
    entity.name: '/DMO/I_Overall_Status_VH',
    entity.element: 'OverallStatus'
    }]
    
    OverallStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    @Semantics.text: true
    StatusText,
    Criticality,
    /* Associations */
    _Agency,
    _Booking : redirected to composition child ZUM_BOOKING_PROC,
    _Currency,
    _Customer,
    _OverallStatus
}
