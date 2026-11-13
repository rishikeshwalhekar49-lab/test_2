" ESE_Test2 | Task 2 | Exception: service/route or capacity not found
CLASS zcx_4929_no_service DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF no_service,
        msgid TYPE symsgid VALUE 'Z4929_ESE_T2',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'SERVICE_ID',
        attr2 TYPE scx_attrname VALUE 'PROVIDER_ID',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_service,
      BEGIN OF no_capacity,
        msgid TYPE symsgid VALUE 'Z4929_ESE_T2',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'SERVICE_CATEGORY',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_capacity.

    DATA service_id       TYPE /dmo/connection_id READ-ONLY.
    DATA provider_id      TYPE /dmo/carrier_id READ-ONLY.
    DATA service_category TYPE /dmo/plane_type_id READ-ONLY.

    METHODS constructor
      IMPORTING
        textid           LIKE if_t100_message=>t100key OPTIONAL
        previous         LIKE previous OPTIONAL
        service_id       TYPE /dmo/connection_id OPTIONAL
        provider_id      TYPE /dmo/carrier_id OPTIONAL
        service_category TYPE /dmo/plane_type_id OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_4929_no_service IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    me->service_id       = service_id.
    me->provider_id      = provider_id.
    me->service_category = service_category.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = no_service.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
