# If necessary, uncomment the line below to include explore_source.

# include: "carlos-training-looker.model.lkml"

view: tttt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: user_id {}
      column: order_item_count {}
      column: total_revenue {}
      derived_column: average_order_revenue {
        sql: total_revenue / order_count ;;
      }
    }
    datagroup_trigger: carlos_training_looker_default_datagroup
  }

  dimension: average_order_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_id {
    description: ""
    type: number
  }
  dimension: user_id {
    primary_key: : yes
    description: ""
    type: number
  }
  dimension: order_item_count {
    description: ""
    type: number
  }
  dimension: total_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
}
