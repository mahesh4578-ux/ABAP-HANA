@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption CDS view'
@Metadata.ignorePropagatedAnnotations: true
@UI: { headerInfo: { typeName: 'Employees', typeNamePlural: 'Employess' ,title: { type: #STANDARD , value: 'Name' }} }
define root view entity ZUM_C_EMP_U as projection on ZUM_I_EMP_U
//composition of target_data_source_name as _association_name
{
       @EndUserText.label: 'Employee No:'
       @UI.facet:[{ 
   
                 purpose: #STANDARD,
                 type: #IDENTIFICATION_REFERENCE,
                 label: 'General Information',
                 id: 'GeneralInfo',
                 position : 10
                 
              }]
             @UI.lineItem:[ { position : 10 } ]
             @UI.identification:[ { position : 10 } ]
             @UI.selectionField:[ { position : 10 } ]
             key empnum,
             @EndUserText.label: 'Name'
             @UI.lineItem:[ { position : 20 } ]
             @UI.identification:[ { position : 20 } ]
             @UI.selectionField:[ { position : 20 } ]
             name,
             @EndUserText.label: 'Age'
             @UI.lineItem:[ { position : 30 } ]
             @UI.identification:[ { position : 30 } ]
             @UI.selectionField:[ { position : 30 } ]
             age             
//    _association_name // Make association public
}
