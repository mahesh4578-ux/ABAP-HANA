@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zum_r_item02 as select from zum_item02
//composition of target_data_source_name as _association_name
{
    key item_id as ItemId,
    name as Name,
    description as Description,
    price as Price,
    status_code as StatusCode,
    
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt
//    _association_name // Make association public
}
