CLASS zcl_um_ve_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  "  INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_um_ve_calc IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
   check not it_original_data is inITIAL.
   data: lt_calc_data tyPE stANDARD TABLE OF zum_travel_proc with deFAULT KEY,
         lv_rate type p deciMALS 2 value '0.025'.

   lt_calc_data = corRESPONDING #( it_original_data ).
   loop at lt_calc_data assIGNING fieLD-SYMBOL(<fs_calc>).
    <fs_calc>-CO2Tax = <fs_calc>-totalprice * lv_rate.
*    <fs_calc>-dayOfTheFlight = 'Saturday'.
    cl_scal_utils=>date_compute_day(
      EXPORTING
        iv_date           = <fs_calc>-begindate
      IMPORTING
*        ev_weekday_number =
        ev_weekday_name   = dATA(lv_day)
    ).
     <fs_calc>-dayOfTheFlight = lv_day.
   endloop.
   ct_calculated_data = corrESPONDING #( lt_calc_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
