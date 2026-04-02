@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zum_c_item02 as projection on zum_r_item02
{
    key ItemId,
    Name,
    Description,
    Price,
    StatusCode
}
