view: ccaa_esperanza_vida_refined {
  sql_table_name: `carlos-avendano-sandbox.sports_movements_dataset.provincia_esperanza_vida_refined` ;;

  dimension: cod_provincia {
    type: string
    sql: ${TABLE}.cod_provincia ;;
    map_layer_name: provinces
  }
  dimension: esperanza_vida {
    type: number
    sql: ${TABLE}.esperanza_vida ;;
  }
  dimension: nombre_provincia {
    type: string
    sql: ${TABLE}.nombre_provincia ;;
  }
  dimension: periodo {
    type: number
    sql: ${TABLE}.Periodo ;;
  }
  dimension: sexo {
    type: string
    sql: ${TABLE}.Sexo ;;
  }
  measure: count {
    type: count
  }
}
