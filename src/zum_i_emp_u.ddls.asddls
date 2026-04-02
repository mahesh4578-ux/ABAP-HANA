@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee cds view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZUM_I_EMP_U as select from zum_emp_det
//composition of target_data_source_name as _association_name
{
    key empnum as empnum,
        name   as name,
        age    as age
     
        
 //   _association_name // Make association public
}
