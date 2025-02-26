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

access_grant: access_test_rsi {
  user_attribute: test_rsi
  allowed_values: [ "yes" ]
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

explore: vista_sql_runner {}

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



  # access_filter: {
  #  field: status
  #  user_attribute: status_filter
  #}



#sql_always_where: ${distribution_centers.name} = "Houston TX" ;;

#always_filter:
#{
#filters: [distribution_centers.name: "Houston TX"]
 #}






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




}

explore: test_region {}

explore: pop_parameters_multi_period {
  label: "PoP Method 4: Compare multiple templated periods"

  sql_always_where:
            {% if pop_parameters_multi_period.current_date_range._is_filtered %} {% condition pop_parameters_multi_period.current_date_range %} ${created_raw} {% endcondition %}
            {% if pop_parameters_multi_period.previous_date_range._is_filtered or pop_parameters_multi_period.compare_to._in_query %}
            {% if pop_parameters_multi_period.comparison_periods._parameter_value == "2" %}
                or DATE(${created_raw}) between  DATE(${period_2_start}) and  DATE(${period_2_end})
{% elsif pop_parameters_multi_period.comparison_periods._parameter_value == "3" %}
    or DATE(${created_raw}) BETWEEN DATE(${period_2_start}) AND DATE(${period_2_end})
    or DATE(${created_raw}) BETWEEN DATE(${period_3_start}) AND DATE(${period_3_end})
            {% elsif pop_parameters_multi_period.comparison_periods._parameter_value == "4" %}
                or  DATE(${created_raw}) between  DATE(${period_2_start}) and  DATE(${period_2_end})
                or  DATE(${created_raw}) between  DATE(${period_3_start})and  DATE(${period_3_end}) or  DATE(${created_raw}) between  DATE(${period_4_start}) and  DATE(${period_4_end})
            {% else %} 1 = 1
            {% endif %}
            {% endif %}
            {% else %} 1 = 1
            {% endif %};;
}
