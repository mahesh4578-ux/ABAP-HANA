CLASS lhc_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Item RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Item RESULT result.
    METHODS checkprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~checkprice.
    METHODS setDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~setDefaultStatus.
    METHODS approveOrder FOR MODIFY
      IMPORTING keys FOR ACTION Item~approveOrder.

ENDCLASS.

CLASS lhc_Item IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD checkprice.
   READ ENTITIES OF zum_r_item02 IN LOCAL MODE
   ENTITY Item                         "zum_r_item02
   ALL FIELDS WITH CORRESPONDING #( keys )
   RESULT DATA(lt_item02).

   LOOP AT lt_item02 ASSiGNING FIELD-SYMBOL(<fs_item02>).
     IF <fs_item02>-price > 20000.
       APPEND VALUE #( %tky = <fs_item02>-%tky ) to failed-item.
       APPEND VALUE #( %tky = <fs_item02>-%tky
                       %msg = new_message_with_text( text = 'Price should not be more than 20000'
                                                     severity = if_abap_behv_message=>severity-error
                                                   )
                     ) to reported-item.
     ENDIF.
   ENDLOOP.

  ENDMETHOD.

  METHOD setDefaultStatus.

   DATA(key) = VALUE #( keys[ 1 ] OPTIONAL ).
   MODIFY  ENTITIES OF zum_r_item02 IN LOCAL MODE
   ENTITY Item
   UPDATE FIELDS ( StatusCode )
   WITH VALUE #(   (   %tky = key-%tky
                StatusCode = 'PEND' ) ).
  ENDMETHOD.

  METHOD approveOrder.

   DATA(key) = VALUE #( keys[ 1 ] OPTIONAL ).
   MODIFY  ENTITIES OF zum_r_item02 IN LOCAL MODE
   ENTITY Item
   UPDATE FIELDS ( StatusCode )
   WITH VALUE #(   (   %tky = key-%tky
                StatusCode = 'APPR' ) ).

  ENDMETHOD.

ENDCLASS.
