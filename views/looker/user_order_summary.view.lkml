
view: user_order_summary {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: order_count {}
      column: total_revenue {}
      derived_column: average_order_revenue {
        sql: total_revenue / order_count ;;
      }
    }
    datagroup_trigger: carlos_training_looker_default_datagroup
  }
  dimension: user_id {
    description: ""
    type: number
  }
  dimension: order_count {
    description: ""
    type: number
  }
  dimension: total_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }

  dimension: average_order_revenue {
    value_format: "$#,##0.00"
    type: number
  }
}
