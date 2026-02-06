CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE booking\_Bookingsupplement.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.
  data max_booking_suppl_id type /dmo/booking_supplement_id.

    READ enTITIES OF ZUM_M_TRAVEL in loCAL MODE
        entity  booking by \_bookingsupplement
        from corRESPONDING #( entities )
        link data(booking_supplements).

    loop at entities assIGNING fiELD-SYMBOL(<booking_group>) groUP BY <booking_group>-%tky.

      loop at booking_supplements into data(ls_booking) using key entity
                                    where source-Travelid = <booking_group>-travelid and
                                          source-BookingId = <booking_group>-BookingId.
         if max_booking_suppl_id < ls_booking-target-bookingsupplementid.
            max_booking_suppl_id = ls_booking-target-bookingsupplementid.
         endif.
      Endloop.
      loop at entities into data(ls_entity) using key entity
                                    where Travelid = <booking_group>-travelid
                                    and   bookingid = <booking_group>-BookingId.
         loop at ls_entity-%target into data(ls_target).
             if max_booking_suppl_id < ls_target-bookingsupplementid.
               max_booking_suppl_id = ls_target-bookingsupplementid.
             endif.
         endloop.

      Endloop.
      loop at entities AssIGNING fIELD-SYMBOL(<booking>) using key entity
                                    where Travelid = <booking_group>-travelid
                                    and  bookingid = <booking_group>-BookingId.
         loop at <booking>-%target assiGNING fiELD-SYMBOL(<bookingsuppl_wo_numbers>).

          append corresPONDING #( <bookingsuppl_wo_numbers> ) to mapped-booksuppl
          assIGNING fielD-SYMBOL(<mapped_bookingsuppl>).
          If <mapped_bookingsuppl>-BookingSupplementId is initIAL.
            max_booking_suppl_id += 1.
            <mapped_bookingsuppl>-BookingSupplementid = max_booking_suppl_id.
          endif.
         endloop.

      Endloop.
    Endloop.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
