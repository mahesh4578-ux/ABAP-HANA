CLASS zcl_um_test_bh_pool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    data:itab type table of string.
    INTERFACES if_oo_adt_classrun .
    metHODS test_method.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_um_test_bh_pool IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
   me->test_method( ).
*   loop at itab into data(wa).
    out->write( exporTING data = itab ).
*   endloop.
  ENDMETHOD.

  METHOD test_method.
   data lv_text TYPE string.
   data(lo_earth)  = new zcl_earth( ).
   data(lo_planet) = new zcl_planet1( ).
   data(lo_mars)   = new zcl_mars( ).

   lv_text = lo_earth->start_engine( ).
   APPEND lv_text TO itab.
   lv_text = lo_earth->leave_orbit( ).
   APPEND lv_text TO itab.

   lv_text = lo_planet->enter_orbit( ).
   APPEND lv_text TO itab.
   lv_text = lo_planet->leave_orbit( ).
   APPEND lv_text TO itab.

   lv_text = lo_mars->enter_orbit( ).
   APPEND lv_text TO itab.
   lv_text = lo_mars->explore_mars( ).
   APPEND lv_text TO itab.
  ENDMETHOD.
ENDCLASS.
