CLASS zcl_um_class1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_um_class1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
   out->write( 'Test Class' ).
  ENDMETHOD.
ENDCLASS.
