view: pop_order_items_delivered {
  view_label: "Order Items (By delivered)"

  filter: sale_price {
    type: number
  }

  sql_table_name: (
    SELECT
        DATE_TRUNC({% parameter pop.within_period_type %}, order_items.shipped_at) AS join_date,
        COUNT(*) AS agg_1,
        SUM(order_items.sale_price) AS agg_2
    FROM order_items
    WHERE {% condition pop_order_items_delivered.sale_price %} order_items.sale_price {% endcondition %}
    GROUP BY 1
    ) ;;

  measure: agg_1 {
    type: number
    label: "Count"
    sql: SUM(${TABLE}.agg_1) ;;
  }

  measure: agg_2 {
    type: number
    label: "Total Sales"
    sql: SUM(${TABLE}.agg_2) ;;
  }
}
