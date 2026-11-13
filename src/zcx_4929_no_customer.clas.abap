" ESE_Test2 | Task 6 | Exception: customer not found (message carries the customer ID)
CLASS zcx_4929_no_customer DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF no_customer,
        msgid TYPE symsgid VALUE 'Z4929_ESE_T2',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'CUSTOMER_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_customer.

    DATA customer_id TYPE /dmo/customer_id READ-ONLY.

    METHODS constructor
      IMPORTING
        textid      LIKE if_t100_message=>t100key OPTIONAL
        previous    LIKE previous OPTIONAL
        customer_id TYPE /dmo/customer_id OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_4929_no_customer IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    me->customer_id = customer_id.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = no_customer.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
