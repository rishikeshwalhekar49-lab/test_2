@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ESE_Test2 T5 - Customer'
define view entity Z4929_CUSTOMER_V
  as select from /dmo/customer
{
  key customer_id                                as CustomerId,
      first_name                                 as FirstName,
      last_name                                  as LastName,
      concat_with_space( first_name, last_name, 1 ) as CustomerName,
      city                                       as City,
      country_code                               as CountryCode
}
