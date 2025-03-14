# The name of this view in Looker is "Distribution Centers"
view: distribution_centers {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker.distribution_centers` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "ID" in Explore.

 dimension: id {
  primary_key: yes
  type: number
  sql: ${TABLE}.id ;;
}

dimension: latitude {
  type: number
  sql: ${TABLE}.latitude ;;
}


dimension: longitude {
  type: number
  sql: ${TABLE}.longitude ;;
}

dimension: name {
  required_access_grants: [access_test_rsi]
  type: string
  sql: ${TABLE}.name ;;
}

measure: count {
  type: count
  drill_fields: [id, name, products.count]
}
}
