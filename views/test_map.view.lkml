# The name of this view in Looker is "Test Map"
view: test_map {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `carlos-avendano-sandbox.Reports.test_map` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Measure" in Explore.

  dimension: measure {
    type: number
    sql: ${TABLE}.measure ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.


  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
    map_layer_name:test_map
  }
  measure: count {
    type: count
  }
}
