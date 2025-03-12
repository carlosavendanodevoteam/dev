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


explore: flexible_pop {
  label: "PoP Method 8: Flexible implementation to compare any period to any other"
  from:  pop_method_8
  view_name: pop_method_8

  # No editing needed - make sure we always join and set up always filter on the hidden config dimensions
  always_join: [within_periods,over_periods]

  always_filter: {
    filters: [date_filter:  "last 12 weeks", within_period_type: "week", over_period_type: "year"]
  }

  # No editing needed
join: within_periods {
  from: numbers_method8
  type: left_outer
  relationship: one_to_many
  fields: []
  sql_on: ${within_periods.n} <= (
    CASE
      WHEN {% parameter pop_method_8.within_period_type %} = 'hour' THEN
        (TIMESTAMP_DIFF(
          TIMESTAMP({% date_end pop_method_8.date_filter %}),
          TIMESTAMP({% date_start pop_method_8.date_filter %}),
          HOUR
        ) - 1)  * 24
      WHEN {% parameter pop_method_8.within_period_type %} = 'day' THEN
        (DATE_DIFF(
          DATE(TIMESTAMP({% date_end pop_method_8.date_filter %})),
          DATE(TIMESTAMP({% date_start pop_method_8.date_filter %})),
          DAY
        ) - 1)
      WHEN {% parameter pop_method_8.within_period_type %} = 'week' THEN
        (DATE_DIFF(
          DATE(TIMESTAMP({% date_end pop_method_8.date_filter %})),
          DATE(TIMESTAMP({% date_start pop_method_8.date_filter %})),
          WEEK
        ) - 1)
      WHEN {% parameter pop_method_8.within_period_type %} = 'month' THEN
        (DATE_DIFF(
          DATE(TIMESTAMP({% date_end pop_method_8.date_filter %})),
          DATE(TIMESTAMP({% date_start pop_method_8.date_filter %})),
          MONTH
        ) - 1)
      WHEN {% parameter pop_method_8.within_period_type %} = 'quarter' THEN
        (DATE_DIFF(
          DATE(TIMESTAMP({% date_end pop_method_8.date_filter %})),
          DATE(TIMESTAMP({% date_start pop_method_8.date_filter %})),
          QUARTER
        ) - 1)
      ELSE
        (DATE_DIFF(
          DATE(TIMESTAMP({% date_end pop_method_8.date_filter %})),
          DATE(TIMESTAMP({% date_start pop_method_8.date_filter %})),
          DAY
        ) - 1)
    END
  );;
}





  # No editing needed
  join: over_periods {
    from: numbers_method8
    view_label: "_PoP"
    type: left_outer
    relationship: one_to_many
    sql_on:
                      CASE WHEN {% condition pop_method_8.over_how_many_past_periods %} NULL {% endcondition %}
                      THEN
                        ${over_periods.n} <= 1
                      ELSE
                        {% condition pop_method_8.over_how_many_past_periods %} ${over_periods.n} {% endcondition %}
                      END;;
  }

  # Rename (& optionally repeat) below join to match your pop view(s)
  join: pop_order_items_method_8 {
    from: pop_order_items_method_8
    type: left_outer
    relationship: many_to_one
    sql_on:
    CASE

    WHEN {% parameter pop_method_8.within_period_type %} = 'hour' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(DATE_ADD({% date_end pop_method_8.date_filter %}, INTERVAL (0 - ${within_periods.n}) HOUR), INTERVAL (0 - ${over_periods.n}) HOUR),
          HOUR
        ))
    WHEN {% parameter pop_method_8.within_period_type %} = 'week' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(DATE_ADD(DATE({% date_end pop_method_8.date_filter %}), INTERVAL (0 - ${within_periods.n}) WEEK), INTERVAL (0 - ${over_periods.n}) WEEK),
          WEEK
        ))


      WHEN {% parameter pop_method_8.within_period_type %} = 'day' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(TIMESTAMP_ADD(TIMESTAMP({% date_end pop_method_8.date_filter %}), INTERVAL (0 - ${within_periods.n}) DAY), INTERVAL (0 - ${over_periods.n}) DAY),
          DAY
        ))

      WHEN {% parameter pop_method_8.within_period_type %} = 'month' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(DATE_ADD(DATE({% date_end pop_method_8.date_filter %}), INTERVAL (0 - ${within_periods.n}) MONTH), INTERVAL (0 - ${over_periods.n}) MONTH),
          MONTH
        ))
      WHEN {% parameter pop_method_8.within_period_type %} = 'quarter' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(DATE_ADD(DATE({% date_end pop_method_8.date_filter %}), INTERVAL (0 - ${within_periods.n}) QUARTER), INTERVAL (0 - ${over_periods.n}) QUARTER),
          QUARTER
        ))
      ELSE
        DATE(DATE_TRUNC(
          DATE_ADD(TIMESTAMP_ADD(TIMESTAMP({% date_end pop_method_8.date_filter %}), INTERVAL (0 - ${within_periods.n}) DAY), INTERVAL (0 - ${over_periods.n}) DAY),
          DAY
        ))
    END
    = DATE(pop_order_items_method_8.join_date) ;;
  }



}
