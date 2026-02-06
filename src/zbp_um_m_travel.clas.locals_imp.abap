CLASS lsc_zum_m_travel DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zum_m_travel IMPLEMENTATION.

  METHOD save_modified.
    data: travel_log_update type STANDARD TABLE OF /dmo/log_travel,
          final_changes  type STANDARD TABLE OF /dmo/log_travel.

    IF update-travel is not initial.

        travel_log_update = CORRESPONDING #( update-travel MAPPING
                                                travel_id = TravelId
         ).

        loop at update-travel ASSIGNING FIELD-SYMBOL(<travel_log_update>).

            ASSIGN travel_log_update[ travel_id = <travel_log_update>-TravelId ]
                to FIELD-SYMBOL(<travel_log_db>).

            get time stamp field <travel_log_db>-created_at.

            if <travel_log_update>-%control-CustomerId = if_abap_behv=>mk-on.

                <travel_log_db>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
                <travel_log_db>-changed_field_name = 'anubhav_customer'.
                <travel_log_db>-changed_value = <travel_log_update>-CustomerId.
                <travel_log_db>-changing_operation = 'CHANGE'.

                append <travel_log_db> to final_changes.

            ENDIF.

            if <travel_log_update>-%control-AgencyId = if_abap_behv=>mk-on.

                <travel_log_db>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
                <travel_log_db>-changed_field_name = 'anubhav_agency'.
                <travel_log_db>-changed_value = <travel_log_update>-AgencyId.
                <travel_log_db>-changing_operation = 'CHANGE'.

                append <travel_log_db> to final_changes.

            ENDIF.

        ENDLOOP.

        insert /dmo/log_travel from table @final_changes.

    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR travel RESULT result.
    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~copytravel.
    METHODS recalctotalprice FOR MODIFY
      IMPORTING keys FOR ACTION travel~recalctotalprice.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel~calculatetotalprice.
    METHODS validateheaderdata FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validateheaderdata.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE travel.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE travel\_booking.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

   DATA:  entity type struCTURE FOR creaTE ZUM_M_TRAVEL,
          travel_id_max type /dmo/travel_id.
 " Step 1: Ensure the travel Id is not set for the record which is coming
   loop AT entities into entity where TravelId is not iniTIAL.
   APPEND CORRESPONDING #( entity ) to mapped-travel.
   endLOOP.
   data(entities_wo_travelid) = entities.
   delete entities_wo_travelid where TravelId IS NOT INITIAL.

 " Step 2: Get the sequence numbers from SNRO
  try.
   cl_numberrange_runtime=>number_get( exporting
                                        nr_range_nr = '01'
                                        object      = conv #( '/DMO/TRAVL' )
                                        quantity = conv #( lines( entities_wo_travelid ) )
                                       importing
                                        number = data(number_range_key)
                                        returncode = data(number_range_return_code)
                                        returned_quantity = data(number_range_returned_quantity)
                                      ).
     catch cx_number_ranges into data(lx_number_ranges)   .
     " Step 3: If there is an exception ,we will throw the error
     loop at entities_wo_travelid into entity.
       append value #( %CID = entity-%cid %key = entity-%key %msg = lx_number_ranges )
       to reported-travel.
       append value #( %CID = entity-%cid %key = entity-%key  )
       to failed-travel.
     endloop.
     exit.
  endtry.

  case number_range_return_code.
   when '1' .
     loop at entities_wo_travelid into entity.
       append value #( %CID = entity-%cid %key = entity-%key
       %msg = new /dmo/cm_flight_messages(
         textid = /dmo/cm_flight_messages=>number_range_depleted
         severity = if_abap_behv_message=>severity-warning
          ) )
       to reported-travel.
     endloop.

   when '2' or '3'.

       append value #( %CID = entity-%cid %key = entity-%key
       %msg = new /dmo/cm_flight_messages(
         textid = /dmo/cm_flight_messages=>not_sufficient_numbers
         severity = if_abap_behv_message=>severity-warning
          ) )
       to reported-travel.
       append value #( %CID = entity-%cid %key = entity-%key
       %fail-cause = if_abap_behv=>cause-conflict
       )
       to failed-travel.
  endcaSE.
 " Step 4: Handle special cases ,number range exceed critical
 " Step 5: The number range return last number
 " Step 6: Final check for all numbers.
  ASSERT number_range_returned_quantity = lines( entities_wo_travelid ).
 " Step 7: assign numbers genreted from number range into travel data and return mapped date to RAP frame work
  travel_id_max = number_range_key - number_range_returned_quantity.
  LOOP AT entities_wo_travelid into entity.
   travel_id_max += 1.
   entity-TravelId = travel_id_max.
   append value #( %CID = entity-%cid %key = entity-%key   )
       to mapped-travel.

  endLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
   data max_booking_id type /dmo/booking_id.

    READ enTITIES OF ZUM_M_TRAVEL in loCAL MODE
        entity  travel by \_booking
        from corRESPONDING #( entities )
        link data(bookings).

    loop at entities assIGNING fiELD-SYMBOL(<travel_group>) groUP BY <travel_group>-travelId.

      loop at bookings into data(ls_booking) using key entity
                                    where source-Travelid = <travel_group>-travelid.
         if max_booking_id < ls_booking-target-bookingid.
            max_booking_id = ls_booking-target-bookingid.
         endif.
      Endloop.
      loop at entities into data(ls_entity) using key entity
                                    where Travelid = <travel_group>-travelid.
         loop at ls_entity-%target into data(ls_target).
             if max_booking_id < ls_target-bookingid.
               max_booking_id = ls_target-bookingid.
             endif.
         endloop.

      Endloop.
      loop at entities AssIGNING fIELD-SYMBOL(<travel>) using key entity
                                    where Travelid = <travel_group>-travelid.
         loop at <travel>-%target assiGNING fiELD-SYMBOL(<booking_wo_numbers>).

          append corresPONDING #( <booking_wo_numbers> ) to mapped-booking assIGNING fielD-SYMBOL(<mapped_booking>).
          If <mapped_booking>-BookingId is initIAL.
            max_booking_id += 10.
            <mapped_booking>-BookingId = max_booking_id.
          endif.
         endloop.

      Endloop.
    Endloop.

  ENDMETHOD.

  METHOD copyTravel.
   DATA: travels type table for create zum_m_travel\\Travel,
         bookings_cba type table for create zum_m_travel\\Travel\_Booking,
         booksuppl_cba type table for create zum_m_travel\\Booking\_BookingSupplement.


   " Step 1: Remove the travel instances which are initial %cid
   Read table keys with key %cid = '' into data(key_with_initial_cid).
   ASSERT key_with_initial_cid is inITIAL.

   read entities of zum_m_travel in local mode
   entity Travel
   ALL FIELDS WITH CORRESPONDING #( keys )
   RESULT DATA(travel_read_result)
   FAILED failed.

   read entities of zum_m_travel in local mode
   entity Travel by \_booking
   ALL FIELDS WITH CORRESPONDING #( travel_read_result )
   RESULT DATA(book_read_result)
   FAILED failed.

   read entities of zum_m_travel in local mode
   entity booking by \_bookingsupplement
   ALL FIELDS WITH CORRESPONDING #( book_read_result )
   RESULT DATA(booksuppl_read_result)
   FAILED failed.

   "Step3: Fill travel internal table for travel data  creation - %cid
   LOOP at travel_read_result assIGNING fiELD-SYMBOL(<travel>).

   " Travel data
    append value #( %cid = keys[ %tky = <travel>-%tky ]-%cid
                   %data = corRESPONDING #( <travel> except travelId )
                  ) to travels assigning fielD-SYMBOL(<new_travel>).

       <new_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
       <new_travel>-EndDate   = cl_abap_context_info=>get_system_date(  ) + 30.
       <new_travel>-OverallStatus = 'O'.

       append value #( %cid_ref = keys[ key entity %tky = <travel>-%tky ]-%cid
                  ) to bookings_cba assigning fielD-SYMBOL(<bookings_cba>).

       LOOP AT book_read_result assignING fieLD-SYMBOL(<booking>)
                                where TravelId = <travel>-travelid.

         append value #( %cid = keys[ key entity %tky = <travel>-%tky ]-%cid && <booking>-BookingId
                         %data = corRESPONDING #( book_read_result[ key entity %tky = <booking>-%tky ] excePT travelid )
          )  to <bookings_cba>-%target asSIGNING fIELD-SYMBOL(<new_booking>).
          <new_booking>-BookingStatus = 'N'.

        append value #( %cid_ref = keys[ key entity %tky = <travel>-%tky ]-%cid && <booking>-bookingid
                  ) to booksuppl_cba assigning fielD-SYMBOL(<booksuppl_cba>).
          LOOP AT booksuppl_read_result assignING fieLD-SYMBOL(<booksuppl>)
                           using key entity  where TravelId = <travel>-travelid
                                              and bookingId = <booking>-bookingid.

        append value #( %cid = keys[ key entity %tky = <travel>-%tky ]-%cid && <booking>-BookingId && <booksuppl>-BookingSupplementId
                      %data = corRESPONDING #( <booksuppl> excePT travelid bookingid ) )  to
           <booksuppl_cba>-%target .


          ENDLOOP.
       ENDLOOP.
   ENDLOOP.

   MODIFY  ENTITIES OF ZUM_m_travel IN LOCAL MODE
   ENTITY travel
   creATE FIELDS (  agencyId customerid begindate enddate bookingfee totalprice currencycode overallstatus )
   with travels
   create by \_booking fields ( bookingid bookingdate customerid carrierid connectionid flightdate flightprice currencycode bookingstatus )
   with bookings_cba
   entity booking
     create by \_bookingSupplement fields ( bookingsupplementid supplementid price currencycode )
     with booksuppl_cba
     mapped data(mapped_create).

    mapped-travel = mapped_create-travel.
  ENDMETHOD.

  METHOD reCalcTotalPrice.
*    Define a structure where we can store all the booking fees and currency code
     TYPES : BEGIN OF ty_amount_per_currency,
                amount type /dmo/total_price,
                currency_code type /dmo/currency_code,
             END OF ty_amount_per_currency.

     data : amounts_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currency.

*    Read all travel instances, subsequent bookings using EML
     READ ENTITIES OF ZUM_m_travel IN LOCAL MODE
        ENTITY Travel
        FIELDS ( BookingFee CurrencyCode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(travels).

     READ ENTITIES OF ZUM_m_travel IN LOCAL MODE
        ENTITY Travel by \_Booking
        FIELDS ( FlightPrice CurrencyCode )
        WITH CORRESPONDING #( travels )
        RESULT DATA(bookings).

     READ ENTITIES OF ZUM_m_travel IN LOCAL MODE
        ENTITY Booking by \_BookingSupplement
        FIELDS ( price CurrencyCode )
        WITH CORRESPONDING #( bookings )
        RESULT DATA(bookingsupplements).

*    Delete the values w/o any currency
     DELETE travels WHERE CurrencyCode is initial.
     DELETE bookings WHERE CurrencyCode is initial.
     DELETE bookingsupplements WHERE CurrencyCode is initial.

*    Total all booking and supplement amounts which are in common currency
     loop at travels ASSIGNING FIELD-SYMBOL(<travel>).
     "Set the first value for total price by adding the booking fee from header
     amounts_per_currencycode = value #( ( amount = <travel>-BookingFee
                                         currency_code = <travel>-CurrencyCode ) ).

*    Loop at all amounts and compare with target currency
        loop at bookings into data(booking) where TravelId = <travel>-TravelId.

            COLLECT VALUE ty_amount_per_currency( amount = booking-FlightPrice
                                                  currency_code = booking-CurrencyCode
            ) into amounts_per_currencycode.

        ENDLOOP.

        loop at bookingsupplements into data(bookingsupplement) where TravelId = <travel>-TravelId.

            COLLECT VALUE ty_amount_per_currency( amount = bookingsupplement-Price
                                                  currency_code = booking-CurrencyCode
            ) into amounts_per_currencycode.

        ENDLOOP.

        clear <travel>-TotalPrice.
*    Perform currency conversion
        loop at amounts_per_currencycode into data(amount_per_currencycode).

            if amount_per_currencycode-currency_code = <travel>-CurrencyCode.
                <travel>-TotalPrice += amount_per_currencycode-amount.
            else.

                /dmo/cl_flight_amdp=>convert_currency(
                  EXPORTING
                    iv_amount               = amount_per_currencycode-amount
                    iv_currency_code_source = amount_per_currencycode-currency_code
                    iv_currency_code_target = <travel>-CurrencyCode
                    iv_exchange_rate_date   = cl_abap_context_info=>get_system_date( )
                  IMPORTING
                    ev_amount               = data(total_booking_amt)
                ).

                <travel>-TotalPrice = <travel>-TotalPrice + total_booking_amt.
            ENDIF.

        ENDLOOP.
*    Put back the total amount

     ENDLOOP.
*    Return the total amount in mapped so the RAP will modify this data to DB
     MODIFY ENTITIES OF    ZUM_m_travel in local mode
     entity travel
     UPDATE FIELDS ( TotalPrice )
     WITH CORRESPONDING #( travels ).
  ENDMETHOD.

  METHOD calculateTotalPrice.
      MODIFY ENTITIES OF ZUM_m_travel IN LOCAL MODE
         entity travel
         execute recalctotalprice
         FROM correSPONDING #( keys ).
  ENDMETHOD.

  METHOD validateheaderdata.

   Read entiTIES OF zum_m_travel  in local mode
    entity travel
    fields ( customerId )
    with corresponding #( keys )
    RESULT data(lt_travel).
    data customers type soRTED TABLE OF /dmo/customer with unique key customer_id.

    customers = corresponding #( lt_travel discarding duplicates mapping
                             customer_id = CustomerId EXCEPT * ).
    delete customers where customer_id is initial.
    IF customers is not initial.
       select from /dmo/customer fieLDS customer_id
       for ALL ENTRIES IN @customers
       where customer_id = @customers-customer_id
       into table @data(lt_cust_db).
    ENDIF.
    loop at lt_travel into data(ls_travel).
      if ( ls_travel-customerid is iniTIAL or
      not line_exists( lt_cust_db[ customer_id = ls_travel-Customerid ] ) ).

       APPEND value #( %tky = ls_travel-%tky ) to failed-travel.
       append value #( %tky =  ls_travel-%tky
                       %element-customerid = if_abap_behv=>mk-on
                       %msg = new /dmo/cm_flight_messages( textid = /dmo/cm_flight_messages=>customer_unkown
                        customer_id = ls_travel-Customerid
                       severity = if_abap_behv_message=>severity-error
                       )
       ) to reported-Travel.

      ENDIf.
    endloop.

  ENDMETHOD.

ENDCLASS.
