CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE Travel.

    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD augment_create.
  data: travel_create type tABLE FOR creaTE zum_m_travel.
  travel_create = corRESPONDING #( entities ).
  loop AT travel_create assIGNING fiELD-SYMBOL(<travel>).
  <travel>-agencyid = '70003'.
  <travel>-OverallStatus = 'O'.
  <travel>-%control-Agencyid = if_abap_behv=>mk-on.
  <travel>-%control-Overallstatus = if_abap_behv=>mk-on.
  ENDLOOP.
  modify augmenting entITIES OF zum_m_travel
  entITY travel
  creATE from travel_create.
  ENDMETHOD.

  METHOD precheck_create.
  ENDMETHOD.

  METHOD precheck_update.
  ENDMETHOD.

ENDCLASS.
