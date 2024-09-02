# Define the database connection to be used for this model.
connection: "carlos-looker-training"

# include all the views
include: "/views/**/*.view.lkml"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: carlos_training_looker_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
  sql_trigger: SELECT max(id) FROM my_tablename ;;
}

persist_with: carlos_training_looker_default_datagroup

map_layer: test_map {
  file: "/maps/final_modified.topojson"
}

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Carlos-training-looker"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: inventory_items {
}


explore: products {}

explore: distribution_centers {}

explore: orders {}

explore: events {}

explore: users {
  always_filter: {
   filters: [age: "20"]
   }
   # sql_always_where: ${age}=20 ;;
}

explore: test_map {}

explore: order_items {

  join: user_order_summary {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_order_summary.user_id};;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: order_details {
   type: left_outer
    sql_on: ${order_items.order_id} = ${order_details.order_id};;
    relationship: many_to_one
  }
  join: siglo {

    type: left_outer

    sql_on: ${order_items.user_id} = ${siglo.user_id};;

    relationship: many_to_one

  }



}

explore: test_region {}
