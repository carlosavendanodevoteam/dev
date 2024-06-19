# If necessary, uncomment the line below to include explore_source.

# include: "carlos-training-looker.model.lkml"

view: siglo {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: user_id {}
      column: order_count {}
      column: order_item_count {}
      derived_column: average_order_revenue {

        sql: order_item_count / order_count ;;

      }

    }
    datagroup_trigger: carlos_training_looker_default_datagroup
  }
  dimension: order_id {
    description: ""
    type: number
  }
  dimension: user_id {
    description: ""
    type: number
  }
  dimension: order_count {
    description: ""
    type: number
  }
  dimension: order_item_count {
    description: ""
    type: number
  }

  dimension: average_order_revenue {

    value_format: "$#,##0.00"

    type: number

  }
}
