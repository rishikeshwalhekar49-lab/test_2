" ESE_Test2 | Test runner | Run with F9 and screenshot the Console output
CLASS zcl_4929_ese_t2_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS test_services     IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_order_report IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_customer     IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_dictionary   IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcl_4929_ese_t2_run IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    test_services( out ).
    test_order_report( out ).
    test_customer( out ).
    test_dictionary( out ).
  ENDMETHOD.

  METHOD test_services.
    out->write( |=== Task 2: service class hierarchy ===| ).

    " Take a real flight from the demo data so the valid case always works
    SELECT SINGLE FROM /dmo/flight
      FIELDS carrier_id, connection_id, plane_type_id
      INTO @DATA(sample).
    IF sy-subrc <> 0.
      out->write( |No rows in /DMO/FLIGHT - generate the demo data first| ).
      RETURN.
    ENDIF.

    " 1) Valid service and category
    TRY.
        DATA(service) = NEW zcl_4929_premium_service(
          i_service_id       = sample-connection_id
          i_provider_id      = sample-carrier_id
          i_service_category = sample-plane_type_id ).
        out->write( |Valid: { service->provider_id } { service->service_id } | &&
                    |{ service->origin_code } -> { service->destination_code }, | &&
                    |capacity { service->get_premium_capacity( ) }| ).
      CATCH zcx_4929_no_service INTO DATA(error).
        out->write( |Unexpected error: { error->get_text( ) }| ).
    ENDTRY.

    " 2) Service that does not exist
    TRY.
        service = NEW zcl_4929_premium_service(
          i_service_id       = '9999'
          i_provider_id      = 'ZZ'
          i_service_category = sample-plane_type_id ).
        out->write( |ERROR: no exception for invalid service| ).
      CATCH zcx_4929_no_service INTO error.
        out->write( |Invalid service -> { error->get_text( ) }| ).
    ENDTRY.

    " 3) Valid service, unknown category
    TRY.
        service = NEW zcl_4929_premium_service(
          i_service_id       = sample-connection_id
          i_provider_id      = sample-carrier_id
          i_service_category = 'NOPLANE' ).
        out->write( |ERROR: no exception for invalid category| ).
      CATCH zcx_4929_no_service INTO error.
        out->write( |Invalid category -> { error->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_order_report.
    out->write( |=== Task 3: order report ===| ).

    " Pick a customer that has orders, and use the calendar year of one order
    SELECT SINGLE FROM /dmo/travel
      FIELDS customer_id, begin_date
      INTO @DATA(sample).
    IF sy-subrc <> 0.
      out->write( |No rows in /DMO/TRAVEL - generate the demo data first| ).
      RETURN.
    ENDIF.

    DATA(date_from) = CONV /dmo/begin_date( |{ sample-begin_date(4) }0101| ).
    DATA(date_to)   = CONV /dmo/end_date( |{ sample-begin_date(4) }1231| ).

    NEW zcl_4929_order_report( )->get_order_summary(
      EXPORTING
        i_customer_id   = sample-customer_id
        i_date_from     = date_from
        i_date_to       = date_to
      IMPORTING
        e_orders        = DATA(orders)
        e_status_counts = DATA(counts) ).

    out->write( |Customer { sample-customer_id }, { date_from DATE = ISO } to { date_to DATE = ISO }| ).
    out->write( orders ).
    out->write( counts ).

    " Self-checks: every row is inside the range, and counts add up to the rows
    LOOP AT orders TRANSPORTING NO FIELDS WHERE order_date < date_from OR order_date > date_to.
      out->write( |ERROR: order outside the date range| ).
      EXIT.
    ENDLOOP.

    DATA(total) = REDUCE i( INIT sum = 0 FOR count IN counts NEXT sum = sum + count-order_count ).
    IF total = lines( orders ).
      out->write( |Check passed: status counts ({ total }) match returned rows| ).
    ELSE.
      out->write( |ERROR: status counts ({ total }) differ from rows ({ lines( orders ) })| ).
    ENDIF.
  ENDMETHOD.

  METHOD test_customer.
    out->write( |=== Task 6: customer lookup ===| ).

    SELECT SINGLE FROM /dmo/customer FIELDS customer_id INTO @DATA(valid_id).
    DATA(model) = NEW zcl_4929_customer_model( ).

    TRY.
        DATA(customer) = model->get_customer( valid_id ).
        out->write( |Valid ID { valid_id }: { customer-first_name } { customer-last_name }, { customer-city }| ).
      CATCH zcx_4929_no_customer INTO DATA(error).
        out->write( |Unexpected error: { error->get_text( ) }| ).
    ENDTRY.

    TRY.
        customer = model->get_customer( '999999' ).
        out->write( |ERROR: no exception for invalid customer| ).
      CATCH zcx_4929_no_customer INTO error.
        out->write( |Invalid ID 999999 -> { error->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_dictionary.
    out->write( |=== Task 7: sorted table type Z4929_T_CUSTOMER_SORTED ===| ).

    DATA customers TYPE z4929_t_customer_sorted.
    SELECT FROM /dmo/customer
      FIELDS customer_id, first_name, last_name, street, postal_code, city, country_code
      ORDER BY customer_id DESCENDING
      INTO CORRESPONDING FIELDS OF TABLE @customers
      UP TO 5 ROWS.

    " Rows were read in descending order but the table keeps them sorted by key
    out->write( customers ).
  ENDMETHOD.

ENDCLASS.
