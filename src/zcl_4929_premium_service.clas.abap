" ESE_Test2 | Task 2 | Subclass: premium service with capacity
" Data source (document in README): /DMO/FLIGHT, where
" SERVICE_CATEGORY = plane type and PREMIUM_CAPACITY = maximum seats.
CLASS zcl_4929_premium_service DEFINITION
  PUBLIC
  INHERITING FROM zcl_4929_service
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        i_service_id       TYPE /dmo/connection_id
        i_provider_id      TYPE /dmo/carrier_id
        i_service_category TYPE /dmo/plane_type_id
      RAISING
        zcx_4929_no_service.

    " PREMIUM_CAPACITY is private; consumers read it only through this getter
    METHODS get_premium_capacity
      RETURNING VALUE(r_capacity) TYPE /dmo/plane_seats_max.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA premium_capacity TYPE /dmo/plane_seats_max.
ENDCLASS.



CLASS zcl_4929_premium_service IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      i_service_id       = i_service_id
      i_provider_id      = i_provider_id
      i_service_category = i_service_category ).

    " SERVICE_CATEGORY is the protected attribute inherited from ZCL_4929_SERVICE
    SELECT SINGLE FROM /dmo/flight
      FIELDS seats_max
      WHERE plane_type_id = @service_category
      INTO @premium_capacity.

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcx_4929_no_service(
        textid           = zcx_4929_no_service=>no_capacity
        service_category = service_category ).
    ENDIF.
  ENDMETHOD.

  METHOD get_premium_capacity.
    r_capacity = premium_capacity.
  ENDMETHOD.

ENDCLASS.
