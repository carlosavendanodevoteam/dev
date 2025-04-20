view: renta_municipios_refined {
  sql_table_name: `carlos-avendano-sandbox.sports_movements_dataset.renta_municipios_refined` ;;

  dimension: a__o {
    type: string
    sql: ${TABLE}.A__o ;;
  }
  dimension: cod_municipio {
    type: string
    sql: ${TABLE}.cod_municipio ;;
    map_layer_name: municipios
  }
  dimension: cod_provincia {
    type: string
    sql: ${TABLE}.cod_provincia ;;
    map_layer_name: provinces
  }
  dimension: nombre_municipio {
    type: string
    sql: ${TABLE}.nombre_municipio ;;
  }
  dimension: nombre_provincia {
    type: string
    sql: ${TABLE}.nombre_provincia ;;
    map_layer_name: municipios
  }
  dimension: par__metro {
    type: string
    sql: ${TABLE}.Par__metro ;;
  }
  dimension: renta_bruta_media {
    type: number
    sql: ${TABLE}.Renta_bruta_media ;;
  }
  dimension: renta_disponible_media {
    type: number
    sql: ${TABLE}.Renta_disponible_media ;;
  }
  measure: count {
    type: count
  }
}
