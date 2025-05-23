# The name of this view in Looker is "Order Items"
view: numbers_method8 {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: (
  SELECT 00 as n UNION ALL SELECT 01 UNION ALL SELECT 02 UNION ALL
  SELECT 03 UNION ALL SELECT 04 UNION ALL SELECT 05 UNION ALL
  SELECT 06 UNION ALL SELECT 07 UNION ALL SELECT 08 UNION ALL
  SELECT 09 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
  SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL
  SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL
  SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL
  SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL
  SELECT 24 UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL
  SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL
  SELECT 30 UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL
  SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35 UNION ALL
  SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL
  SELECT 39 UNION ALL SELECT 40 UNION ALL SELECT 41 UNION ALL
  SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL
  SELECT 45 UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL
  SELECT 48 UNION ALL SELECT 49 UNION ALL SELECT 50 UNION ALL
  SELECT 51 UNION ALL SELECT 52 )
  ;;


  dimension: n {
    type: number
    hidden:  yes
    sql: ${TABLE}.n ;;
  }
}
