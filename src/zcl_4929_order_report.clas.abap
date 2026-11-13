" ESE_Test2 | Task 3 | Customer orders in a date range, with counts by status
" Data source (document in README): /DMO/TRAVEL, where one travel = one order,
" order date = BEGIN_DATE and amount = TOTAL_PRICE.
CLASS zcl_4929_order_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_order,
        order_id      TYPE /dmo/travel_id,
        order_date    TYPE /dmo/begin_date,
        status        TYPE /dmo/travel_status,
        amount        TYPE /dmo/total_price,
        currency_code TYPE /dmo/currency_code,
      END OF ty_order,
      tt_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY,

      BEGIN OF ty_status_count,
        status      TYPE /dmo/travel_status,
        order_count TYPE i,
      END OF ty_status_count,
      tt_status_counts TYPE STANDARD TABLE OF ty_status_count WITH EMPTY KEY.

    METHODS get_order_summary
      IMPORTING
        i_customer_id   TYPE /dmo/customer_id
        i_date_from     TYPE /dmo/begin_date
        i_date_to       TYPE /dmo/end_date
      EXPORTING
        e_orders        TYPE tt_orders
        e_status_counts TYPE tt_status_counts.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4929_order_report IMPLEMENTATION.

  METHOD get_order_summary.
    CLEAR: e_orders, e_status_counts.

    SELECT FROM /dmo/travel
      FIELDS travel_id   AS order_id,
             begin_date  AS order_date,
             status,
             total_price AS amount,
             currency_code
      WHERE customer_id = @i_customer_id
        AND begin_date BETWEEN @i_date_from AND @i_date_to
      ORDER BY travel_id
      INTO CORRESPONDING FIELDS OF TABLE @e_orders.

    " Same WHERE clause as above, so the counts always match the returned rows
    SELECT FROM /dmo/travel
      FIELDS status,
             COUNT( * ) AS order_count
      WHERE customer_id = @i_customer_id
        AND begin_date BETWEEN @i_date_from AND @i_date_to
      GROUP BY status
      ORDER BY status
      INTO CORRESPONDING FIELDS OF TABLE @e_status_counts.
  ENDMETHOD.

ENDCLASS.
