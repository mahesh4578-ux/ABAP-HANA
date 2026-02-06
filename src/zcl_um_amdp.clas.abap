CLASS zcl_um_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .
    CLASS-METHODS : add_numbers  amdp options cds session client dependent importing value(a) type i
                                         value(b) type i
                                exporting value(result) TYPE i   .
    CLASS-METHODS : get_customer_by_id amdp options cds session client dependent
                                       impoRTING valUE(iv_cust_id) type zum_btp_del_no
                                       exportING value(e_res) type string.
    CLASS-METHODS : get_product_by_mrp amdp options cds session client dependent
                                       impoRTING valUE(i_tax) type i
                                       exportING value(out_tab) type ZUM_BTP_TT_PROD_MRP.
    CLASS-METHODS : get_total_sales
                         for table FUNCTION ZUM_BTP_CDS_TFUNC .
    METHODS: get_new_variable RETURNING value(r_result) TYPE REF TO if_oo_adt_classrun_out.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: new_variable TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcl_um_amdp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

   zcl_um_amdp=>get_product_by_mrp( exporting i_tax = 18 importing out_tab = data(itab) ) .
   out->write( expORTING data = itab ).

*   zcl_um_amdp=>get_customer_by_id(  exporting iv_cust_id = '629ED56B4A611FE0B6BC562EB55D1847'
*                       importing e_res = data(res) ).
*                       out->write( expORTING data = | result :{ res }| ).

*   zcl_um_amdp=>add_numbers( exporting a = 10
*                     b = 10
*                      IMPORTING result = data(lv_res) ).
*
*          out->write(  xpORTING data = | result :{ lv_res }|
*          ).

  ENDMETHOD.

  METHOD add_numbers by datABASE pROCEDURE FOR HDB LANGUAGE sqlSCRIPT opTIONS reAD-ONLY.
    DECLARE x intEGER;
    DECLARE y integer;
    x := a;
    y := b;

    result := :x + :y;


  ENDMETHOD.

  METHOD get_new_variable.
    r_result = me->new_variable.
  ENDMETHOD.

  METHOD get_customer_by_id by datABASE pROCEDURE FOR HDB LANGUAGE sqlSCRIPT opTIONS reAD-ONLY
                            using zum_btp_custtab.
   select company_name into e_res from zum_btp_custtab where cust_id = :iv_cust_id;
  ENDMETHOD.

  METHOD get_product_by_mrp by datABASE pROCEDURE FOR HDB LANGUAGE sqlSCRIPT opTIONS reAD-ONLY
                            using zum_btp_mattab.
   declare lv_count integer;
   declare i integer;
   declare lv_mrp bigint;
   declare lv_price_d integer;

   lt_prod = select * from zum_btp_mattab;

   lv_count := record_count( :lt_prod );
   for i in 1..:lv_count do
   lv_price_d  :=  :lt_prod.price[i] * ( 100 - :lt_prod.discount[i]) / 100;
   lv_mrp :=  :lv_price_d *  ( 100 + :i_tax ) / 100;
   IF lv_mrp > 15000 then
     lv_mrp := :lv_mrp * 0.90;
   END IF;
   :out_tab.insert( ( :lt_prod.name[i],
                      :lt_prod.category[i],
                      :lt_prod.price[i],
                      :lt_prod.currency[i],
                      :lt_prod.discount[i],
                      :lv_price_d,
                      :lv_mrp
                         ), i );
   end for ;


  ENDMETHOD.

  METHOD get_total_sales by DATABASE fUNCTION FOR HDB LANGUAGE SQLSCRIPT
                        opTIONS reAD-ONLY
                        usING Zum_btp_custtab zum_btp_ord_h zum_btp_ord_i.
   retURN  Select cust.client,
           cust.company_name,
           sum(item.amount) as total_sales,
           item.currency as currency_code,
           rank ( ) OVER( order BY sum( item.amount ) desc ) as customer_rank

            from Zum_btp_custtab as cust
            innER join zum_btp_ord_h as sls
            on cust.cust_id = sls.buyer
            innER join  zum_btp_ord_i as item
            on sls.order_id = item.order_id
            group by cust.client,
                     cust.company_name,
                     item.currency liMIT 3;



  ENDMETHOD.

ENDCLASS.
