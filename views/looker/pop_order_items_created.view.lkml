view: pop_order_items_created {
  view_label: "Order Items (By created date)"
  sql_table_name: (
    SELECT
        DATE_TRUNC({% parameter pop.within_period_type %}, order_items.created_at) as join_date,
        COUNT(*) as agg_1,
        SUM(order_items.sale_price) as agg_2
        FROM order_items
    -- Could add templated filters here
    -- OPTIONAL : Filter inner query on min/max dates (since query optimizer probably won't)
        GROUP BY 1
        ) ;;

  measure:  agg_1 {
    type:  number
    label: "Count"
    sql: SUM(${TABLE}.agg_1) ;;
  }
  measure:  agg_2 {
    type:  number
    label: "Total Sales"
    sql: SUM(${TABLE}.agg_2) ;;
  }
}
