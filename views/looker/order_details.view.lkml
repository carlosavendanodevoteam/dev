# If necessary, uncomment the line below to include explore_source.

# include: "carlos-training-looker.model.lkml"

view: order_details {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: user_id {}
      column: total_revenue {}
      column: order_count {}
    }
  }
  dimension: order_id {
    description: ""
    primary_key: yes
    type: number
  }
  dimension: user_id {
    description: ""
    type: number
  }
  dimension: total_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_count {
    description: ""
    type: number
  }
}
