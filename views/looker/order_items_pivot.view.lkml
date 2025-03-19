view: ventas_pivotadas {
  derived_table: {
    sql:
      SELECT 'Total de Ventas' AS metrica, fecha, total_ventas AS valor
      FROM order_items
      UNION ALL
      SELECT 'Cantidad de Productos' AS metrica, fecha, cantidad_productos AS valor
      FROM order_items
    ;;
  }

  dimension: metrica {
    type: string
    sql: ${TABLE}.metrica ;;
  }

  dimension: fecha {
    type: date
    sql: ${TABLE}.fecha ;;
  }

  measure: valor {
    type: sum
    sql: ${TABLE}.valor ;;
  }
}
