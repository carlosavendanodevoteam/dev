view: pop_order_items_method_8 {
  view_label: "Order Items (By created date)"
  sql_table_name: (
    SELECT
  CASE
    WHEN {% parameter pop_method_8.within_period_type %} = 'hour' THEN
      DATE_TRUNC(
        order_items.created_at,
        HOUR
      )
    WHEN {% parameter pop_method_8.within_period_type %} = 'day' THEN
      DATE_TRUNC(
        order_items.created_at,
        DAY
      )
    WHEN {% parameter pop_method_8.within_period_type %} = 'week' THEN
      DATE_TRUNC(
        order_items.created_at,
        WEEK
      )
    WHEN {% parameter pop_method_8.within_period_type %} = 'month' THEN
      DATE_TRUNC(
        order_items.created_at,
        MONTH
      )
    WHEN {% parameter pop_method_8.within_period_type %} = 'quarter' THEN
      DATE_TRUNC(
        order_items.created_at,
        QUARTER
      )
    ELSE
      DATE_TRUNC(
        order_items.created_at,
        DAY
      )
  END as join_date,
  COUNT(*) as agg_1,
  SUM(order_items.sale_price) as agg_2
FROM order_items
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
