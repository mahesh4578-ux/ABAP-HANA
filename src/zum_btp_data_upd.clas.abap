CLASS zum_btp_data_upd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS fill_transaction_data.
    METHODS fill_master_data.
    METHODS flush.
ENDCLASS.



CLASS zum_btp_data_upd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    flush( ).
    fill_master_data( ).
    fill_transaction_data(  ).
    out->write(  data = 'Success' ).
  ENDMETHOD.
  METHOD fill_master_data.
  DATA : lt_cust   TYPE TABLE OF zum_btp_custtab,
         lt_prod   TYPE TABLE OF zum_btp_mattab.

    TRY.
        APPEND VALUE #(
                         cust_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         type = 'SP'
                         company_name = 'COMP1'
                         street   = 'STREET1'
                         country  = 'IN'
                         city     = 'CITY1'
                         )
                         TO lt_cust.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                         cust_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         type = 'SP'
                         company_name = 'COMP22'
                         street   = 'STREET2'
                         country  = 'JP'
                         city     = 'CITY2'
                         )
                         TO lt_cust.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                         cust_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         type = 'SP'
                         company_name = 'COMP333'
                         street   = 'STREET3'
                         country  = 'JP'
                         city     = 'CITY3'
                         )
                         TO lt_cust.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                         cust_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         type = 'SP'
                         company_name = 'COMP444'
                         street   = 'STREET4'
                         country  = 'MX'
                         city     = 'CITY4'
                         )
                         TO lt_cust.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                         cust_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         type = 'SP'
                         company_name = 'COMP5'
                         street   = 'STREET5'
                         country  = 'US'
                         city     = 'CITY5'
                         )
                         TO lt_cust.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                         cust_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         type = 'SP'
                         company_name = 'COMP6'
                         street   = 'STREET6'
                         country  = 'US'
                         city     = 'CITY6'
                         )
                         TO lt_cust.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                         cust_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         type = 'SP'
                         company_name = 'COMP7'
                         street   = 'STREET7'
                         country  = 'IN'
                         city     = 'CITY7'
                         )
                         TO lt_cust.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                         cust_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         type = 'SP'
                         company_name = 'COMP8'
                         street   = 'STREET8'
                         country  = 'IN'
                         city     = 'CITY8'
                         )
                         TO lt_cust.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

 " Products
    TRY.
        APPEND VALUE #(
                         mat_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                         name = 'Laptop'
                         category = 'PCs'
                         price = 15000
                         currency = 'INR'
                         discount = 3
                         )
                         TO lt_prod.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                        mat_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                        name = 'Mouse'
                        category = 'PCs'
                        price = 2500
                        currency = 'INR'
                        discount = 2
                        )
                        TO lt_prod.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                        mat_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                        name = 'Smart Office'
                        category = 'Software'
                        price = 1540
                        currency = 'INR'
                        discount = 32
                        )
                        TO lt_prod.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                        mat_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                        name = 'Smart Design'
                        category = 'Software'
                        price = 2400
                        currency = 'INR'
                        discount = 12
                        )
                        TO lt_prod.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                        mat_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                        name = 'Transcend Carry pocket'
                        category = 'PCs'
                        price = 14000
                        currency = 'INR'
                        discount = 7
                        )
                        TO lt_prod.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    TRY.
        APPEND VALUE #(
                        mat_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                        name = 'Gaming Monster Pro'
                        category = 'PCs'
                        price = 15500
                        currency = 'INR'
                        discount = 8
                        )
                        TO lt_prod.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    INSERT zum_btp_custtab FROM TABLE @lt_cust.
    INSERT zum_btp_mattab  FROM TABLE @lt_prod.



  ENDMETHOD.

  METHOD fill_transaction_data.
DATA : o_rand    TYPE REF TO cl_abap_random_int,
           n         TYPE i,
           seed      TYPE i,
           lv_date   TYPE timestamp,
           lv_ord_id TYPE zum_btp_del_no,
           lt_so     TYPE TABLE OF zum_btp_ord_h,
           lt_so_i   TYPE TABLE OF zum_btp_ord_i.

    seed = cl_abap_random=>seed( ).
    cl_abap_random_int=>create(
      EXPORTING
        seed = seed
        min  = 1
        max  = 7
      RECEIVING
        prng = o_rand
    ).
    GET TIME STAMP FIELD lv_date.

    SELECT * FROM zum_btp_custtab INTO TABLE @DATA(lt_cust).
    SELECT * FROM zum_btp_mattab INTO TABLE @DATA(lt_prod).

    DO 10 TIMES.
      TRY.
          lv_ord_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32(  ).
        CATCH cx_uuid_error.
          "handle exception
      ENDTRY.

      n = o_rand->get_next( ).
      READ TABLE lt_cust INTO DATA(ls_bp) INDEX n.
      APPEND VALUE #(
              order_id = lv_ord_id
              order_no = sy-index
              buyer = ls_bp-cust_id
              gross_amount = 10 * n
              currency = 'EUR'
              created_by = sy-uname
              created_on = lv_date
              changed_by = sy-uname
              changed_on = lv_date
       ) TO lt_so.
      DO 2 TIMES.
        READ TABLE lt_prod INTO DATA(ls_prod) INDEX n.
        TRY.
            APPEND VALUE #(
                item_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32(  )
                order_id = lv_ord_id
                product = ls_prod-mat_id
                qty =  n
                uom = 'EA'
                amount =  n * ls_prod-price
                currency = ls_prod-currency
         ) TO lt_so_i.
          CATCH cx_uuid_error.
            "handle exception
        ENDTRY.
        wait up to 1 seconds.
      ENDDO.
    ENDDO.

    INSERT zum_btp_ord_h FROM TABLE @lt_so.
    INSERT zum_btp_ord_i FROM TABLE @lt_so_i.

  ENDMETHOD.

  METHOD flush.

  DELETE FROM : zum_btp_custtab, zum_btp_mattab, zum_btp_ord_h, zum_btp_ord_i.

  ENDMETHOD.

ENDCLASS.
