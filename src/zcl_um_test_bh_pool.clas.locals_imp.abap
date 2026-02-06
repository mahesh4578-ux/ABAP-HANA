*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class zcl_earth defiNITION.
 public section.
   mETHODS start_engine retURNING value(r_value) type string.
   mETHODS leave_orbit retURNING value(r_value) type string.
endCLASS.
class zcl_earth imPLEMENTATION.
   methOD start_engine.
      r_value = 'Test1'.
   endmethod.
   methOD leave_orbit.
      r_value = 'Test2'.
   endmethod.
endCLASS.
class zcl_planet1 defiNITION.
 public section.
   mETHODS enter_orbit retURNING  value(r_value) type string.
   mETHODS leave_orbit retURNING  value(r_value) type string.
endCLASS.
class zcl_planet1 imPLEMENTATION.
   method enter_orbit.
       r_value = 'Test3'.
   endmethod.
   method leave_orbit.
       r_value = 'Test4'.
   endmethod.
endCLASS.
class zcl_mars defiNITION.
 public section.
  mETHODS enter_orbit retURNING value(r_value) type string.
   mETHODS explore_mars retURNING value(r_value) type string.
endCLASS.
class zcl_mars imPLEMENTATION.
  method enter_orbit.
     r_value = 'Test5'.
  enDMETHOD.
  method explore_mars.
     r_value = 'Test6'.
  enDMETHOD.
endCLASS.
