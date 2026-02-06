CLASS zcl_um_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    data: lv_opr TYPE c VALUE 'U'.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_um_eml IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
   CASE lv_opr.
    WHEN 'R'.
       READ ENTITIES OF ZUM_M_TRAVEL
       ENTITY Travel
        FIELDS ( TravelId AgencyId CustomerId OverallStatus )
        WITH  VALUE #( ( TravelId = '00000010' )
                ( TravelId = '00000024' )
                ( TravelId = '009595' )
              )
              ReSULT DATA(lt_result)
              FAILED DATA(lt_failed)
              REPORTED DATA(lt_messages).
              out->write( expORTING
                          data =  lt_result
                        ).

              out->write( expORTING
                          data =  lt_failed
                        ).
    WHEN 'C'.
      data(lv_description) = 'RAP'.
      data(lv_agency) = '070016'.
      data(lv_customer) = '000697'.
*     MODIFY ENTITIES OF ZUM_M_travel
*          ENTITY Travel
*          CREATE FIELDS ( TravelId AgencyId CurrencyCode BeginDate EndDate Description
*                          OverallStatus )
*          WITH VALUE #(
*                       ( %CID =  'TEST'
*                         TravelId = '00001133'
*                         AgencyId = lv_agency
*                         CustomerId = lv_customer
*                         Begindate = cl_abap_context_info=>get_system_date(  )
*                         EndDate = cl_abap_context_info=>get_system_date(  ) + 30
*                         Description = lv_description
*                         OverallStatus = 'P'
*                        )
*                        ( %CID =  'TEST-1'
*                         TravelId = '00001135'
*                         AgencyId = lv_agency
*                         CustomerId = lv_customer
*                         Begindate = cl_abap_context_info=>get_system_date(  )
*                         EndDate = cl_abap_context_info=>get_system_date(  ) + 30
*                         Description = lv_description
*                         OverallStatus = 'P'
*                        )
*                        ( %CID =  'TEST-2'
*                         TravelId = '00000010'
*                         AgencyId = lv_agency
*                         CustomerId = lv_customer
*                         Begindate = cl_abap_context_info=>get_system_date(  )
*                         EndDate = cl_abap_context_info=>get_system_date(  ) + 30
*                         Description = lv_description
*                         OverallStatus = 'P'
*                        )
*
*                     )
*                     MAPPED DATA(lt_mapped)
*                     FAILED lt_failed
*                     REPORTED lt_messages.
*                     COMMIT ENTITIES.
*                    out->write( expORTING
*                          data =  lt_result
*                        ).
*
*                    out->write( expORTING
*                          data =  lt_failed
*                        ).

    WHEN 'U'.
         lv_description = 'RAP UPD'.
         lv_agency      = '070032'.
          MODIFY ENTITIES OF ZUM_M_travel
          ENTITY Travel
          UPDATE FIELDS ( AgencyId  Description )
          WITH VALUE #(
                       ( TravelId = '00001133'
                         AgencyId = lv_agency
                         Description = lv_description
                        )
                        ( TravelId = '00001135'
                         AgencyId = lv_agency
                         Description = lv_description
                        )
                        ( TravelId = '00000010'
                         AgencyId = lv_agency
                         Description = lv_description
                        )

                     )
                     MAPPED DATA(lt_mapped)
                     FAILED lt_failed
                     REPORTED lt_messages.

                     COMMIT ENTITIES.
                    out->write( expORTING
                          data =  lt_result
                        ).

                    out->write( expORTING
                          data =  lt_failed
                        ).
    WHEN 'D'.
          MODIFY ENTITIES OF ZUM_M_travel
          ENTITY Travel
          DELETE FROM VALUE #(
                       ( TravelId = '00001133'
                        )

                     )
                     MAPPED lt_mapped
                     FAILED lt_failed
                     REPORTED lt_messages.

                     COMMIT ENTITIES.
                    out->write( expORTING
                          data =  lt_result
                        ).

                    out->write( expORTING
                          data =  lt_failed
                        ).

   ENDCASE.
  ENDMETHOD.
ENDCLASS.
