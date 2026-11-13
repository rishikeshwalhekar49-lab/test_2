" ESE_Test2 | Task 2 | Superclass: scheduled service
" Data source (document in README): /DMO/CONNECTION, where
" SERVICE_ID = connection ID and PROVIDER_ID = carrier ID.
CLASS zcl_4929_service DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA service_id       TYPE /dmo/connection_id READ-ONLY.
    DATA provider_id      TYPE /dmo/carrier_id READ-ONLY.
    DATA origin_code      TYPE /dmo/airport_from_id READ-ONLY.
    DATA destination_code TYPE /dmo/airport_to_id READ-ONLY.

    METHODS constructor
      IMPORTING
        i_service_id       TYPE /dmo/connection_id
        i_provider_id      TYPE /dmo/carrier_id
        i_service_category TYPE /dmo/plane_type_id
      RAISING
        zcx_4929_no_service.

  PROTECTED SECTION.
    " Visible to subclasses, hidden from consumers
    DATA service_category TYPE /dmo/plane_type_id.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4929_service IMPLEMENTATION.

  METHOD constructor.
    service_id       = i_service_id.
    provider_id      = i_provider_id.
    service_category = i_service_category.

    SELECT SINGLE FROM /dmo/connection
      FIELDS airport_from_id, airport_to_id
      WHERE carrier_id    = @i_provider_id
        AND connection_id = @i_service_id
      INTO ( @origin_code, @destination_code ).

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcx_4929_no_service(
        textid      = zcx_4929_no_service=>no_service
        service_id  = i_service_id
        provider_id = i_provider_id ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
