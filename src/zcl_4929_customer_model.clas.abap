" ESE_Test2 | Task 6 | Customer model with typed exception
CLASS zcl_4929_customer_model DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_customer,
        customer_id  TYPE /dmo/customer_id,
        first_name   TYPE /dmo/first_name,
        last_name    TYPE /dmo/last_name,
        street       TYPE /dmo/street,
        postal_code  TYPE /dmo/postal_code,
        city         TYPE /dmo/city,
        country_code TYPE land1,
      END OF ty_customer.

    METHODS get_customer
      IMPORTING
        i_customer_id     TYPE /dmo/customer_id
      RETURNING
        VALUE(r_customer) TYPE ty_customer
      RAISING
        zcx_4929_no_customer.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4929_customer_model IMPLEMENTATION.

  METHOD get_customer.
    SELECT SINGLE FROM /dmo/customer
      FIELDS customer_id, first_name, last_name, street, postal_code, city, country_code
      WHERE customer_id = @i_customer_id
      INTO CORRESPONDING FIELDS OF @r_customer.

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcx_4929_no_customer(
        textid      = zcx_4929_no_customer=>no_customer
        customer_id = i_customer_id ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
