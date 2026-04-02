
CLASS lcl_buffer DEFINITION CREATE PRIVATE.

PUBLIC SECTION.
types :ty_dec type p leNGTH 6 deCIMALS 0.
Methods set_create_value importing ls_employee TYPE zum_emp_det.
Methods set_update_value importing ls_employee TYPE zum_emp_det.


Methods get_records importing iv_empnum type ty_dec
                    returniNG value(ls_employee) TYPE zum_emp_det .

CLASS-METHODS get_instance

RETURNING VALUE(ro_instance) TYPE REF TO lcl_buffer.



PRIVATE SECTION.

CLASS-DATA: go_instance TYPE REF TO lcl_buffer.

ENDCLASS.


CLASS lcl_buffer IMPLEMENTATION.

METHOD get_instance.

IF go_instance IS NOT BOUND.

go_instance = NEW #( ).

ENDIF.

ro_instance = go_instance.

ENDMETHOD.

  METHOD set_create_value.
   INSERT into zum_emp_det values @ls_employee.
  ENDMETHOD.

  METHOD set_update_value.
   MODIFY zum_emp_det FROM @ls_employee.
  ENDMETHOD.

  METHOD get_records.
   select siNGLE * from zum_emp_det where empnum = @iv_empnum into @ls_employee.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZUM_I_EMP_U DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zum_i_emp_u RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zum_i_emp_u RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zum_i_emp_u.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zum_i_emp_u.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zum_i_emp_u.

    METHODS read FOR READ
      IMPORTING keys FOR READ zum_i_emp_u RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zum_i_emp_u.

ENDCLASS.

CLASS lhc_ZUM_I_EMP_U IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
  DATA(lo_instance) = lcl_buffer=>get_instance( ).
  DATA ls_employee TYPE zum_emp_det.
  LOOP AT ENTITIES ASSIGNING FIELD-SYMBOL(<fs_entity>).
   ls_employee-empnum = <fs_entity>-empnum.
   ls_employee-name   = <fs_entity>-name.
   ls_employee-age    = <fs_entity>-age.
   lo_instance->set_create_value( ls_employee ).
   inSERT value #( %cid = <fs_entity>-%cid empnum = ls_employee-empnum ) INTO table mapped-employee.

  ENDLOOP.
  ENDMETHOD.

  METHOD update.
  DATA(lo_instance) = lcl_buffer=>get_instance( ).

  LOOP AT ENTITIES ASSIGNING FIELD-SYMBOL(<fs_entity>).
   DATA(ls_employee) = lo_instance->get_records(  <fs_entity>-empnum ).
   IF ls_employee IS NOT INITIAL.
    DATA(ls_control) = <fs_entity>-%control.
    IF ls_employee-name IS NOT INITIAL.
      ls_employee-name   = <fs_entity>-name.
    endif.
    if LS_employee-AGE is not inITIAL.
      ls_employee-age    = <fs_entity>-age.
    ENDIF.
   lo_instance->set_UPDATE_value( ls_employee ).

   ENDIF.
  ENDLOOP.
  ENDMETHOD.

  METHOD delete.
  DATA : lt_employee TYPE TABLE OF zum_emp_det,
         ls_employee TYPE zum_emp_det.
   LOOP AT KEYS ASSIGNING fiELD-SYMBOL(<fs_employee>).
    ls_employee-empnum = <fs_employee>-empnum.
    appEND ls_employee to lt_employee.
   ENDLOOP.

   DATA(lo_instance) = lcl_buffer=>get_instance(  ) .
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZUM_I_EMP_U DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZUM_I_EMP_U IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
