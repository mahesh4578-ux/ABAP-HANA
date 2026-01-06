@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer View Entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_UM_CUST_ENT as select from zum_btp_custtab
association[1] to I_Country as _Country on
$projection.CountryCode = _Country.Country
{
    key cust_id as CustId,
    type as Type,
    company_name as CompanyName,
    street as Street,
    country as CountryCode,
    city as City,
    _Country._Text[Language = $session.system_language].CountryName as CountryName
    }
