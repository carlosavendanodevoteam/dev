
view: sql_runner_query {
  derived_table: {
    sql: SELECT
        order_items.user_id AS user_id
        ,COUNT(order_items.order_id) AS order_count
        ,SUM(order_items.sale_price) AS order_revenue    
      FROM cloud-training-demos.looker_ecomm.order_items
      GROUP BY user_id
      LIMIT 10 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: order_revenue {
    type: number
    sql: ${TABLE}.order_revenue ;;
  }

  set: detail {
    fields: [
        user_id,
	order_count,
	order_revenue
    ]
  }
}
