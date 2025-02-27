view: pop_order_items_created {
  view_label: "Order Items (By created date)"
  sql_table_name: (
    SELECT
        DATE_TRUNC({% parameter pop.within_period_type %}, order_items.created_at) AS join_date,
        COUNT(*) AS agg_1,
        SUM(order_items.sale_price) AS agg_2
    FROM order_items
    -- Podrías agregar filtros plantillados aquí
    -- OPCIONAL: Filtrar la consulta interna por fechas mínimas/máximas (ya que el optimizador de consultas probablemente no lo hará)
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
