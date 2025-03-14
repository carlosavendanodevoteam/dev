view: numbers {
  sql_table_name: UNNEST(GENERATE_ARRAY(0, 52)) AS n ;;
  dimension: n {
    type: number
    hidden: yes
    sql: ${TABLE}.n ;;
  }
}
