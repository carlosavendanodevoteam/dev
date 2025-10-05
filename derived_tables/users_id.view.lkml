view: users_id {
  derived_table: {
    sql: SELECT
    CONCAT((CONVERT(user.first_name USING utf8mb4)), ' ', (CONVERT(user.last_name USING utf8mb4)))  AS `name`,
    user.id AS `id`
FROM history
LEFT JOIN user  AS user ON history.user_id = user.id
GROUP BY
    1,
    2 ;;
  }




  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.di ;;
  }

}
