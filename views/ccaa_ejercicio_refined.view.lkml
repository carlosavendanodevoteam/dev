view: ccaa_ejercicio_refined {
  sql_table_name: `carlos-avendano-sandbox.sports_movements_dataset.ccaa_ejercicio_refined` ;;

  dimension: cod_ccaa {
    type: string
    sql: ${TABLE}.cod_ccaa ;;
    map_layer_name: comunidades
  }
  dimension: comunidades_y_ciudades_aut__nomas {
    type: string
    sql: ${TABLE}.Comunidades_y_Ciudades_Aut__nomas ;;
  }
  dimension: nombre_ccaa {
    type: string
    sql: ${TABLE}.nombre_ccaa ;;
  }
  dimension: periodo {
    type: string
    sql: ${TABLE}.Periodo ;;
  }
  dimension: tipo_de_ejercicio {
    type: string
    sql: ${TABLE}.Tipo_de_ejercicio ;;
  }
  dimension: total {
    type: number
    sql: ${TABLE}.Total ;;
  }

  dimension: total_pct {
    type: number
    sql: ${total}/1000 ;;
  }
  dimension: total_nacional {
    type: string
    sql: ${TABLE}.Total_Nacional ;;
  }
  measure: count {
    type: count
  }
}
