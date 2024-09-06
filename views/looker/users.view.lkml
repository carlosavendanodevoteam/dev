# The name of this view in Looker is "Users"
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker.users` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Age" in Explore.

dimension: id {
  primary_key: yes
  type: number
  sql: ${TABLE}.id ;;
}

dimension: age {
  type: number
  sql: ${TABLE}.age ;;
}

  dimension: age_tier {

    type: tier

    tiers: [18, 25, 35, 45, 55, 65, 75, 90]

    sql: ${age} ;;

    style: interval

  }




dimension: city {
  type: string
  sql: ${TABLE}.city ;;
}

dimension: country {
  type: string
  map_layer_name: countries
  sql: ${TABLE}.country ;;
}

dimension_group: created {
  type: time
  timeframes: [
    raw,
    time,
    date,
    week,
    month,
    quarter,
    year
  ]
  sql: ${TABLE}.created_at ;;
}


  dimension: days_since_signup {

    type: number

    sql: DATE_DIFF(current_date(), ${created_date}, DAY);;

  }

dimension: email {
  type: string
  sql: ${TABLE}.email ;;
}

dimension: first_name {
  type: string
  sql: ${TABLE}.first_name ;;
}

dimension: gender {
  type: string
  sql: ${TABLE}.gender ;;
}

dimension: last_name {
  type: string
  sql: ${TABLE}.last_name ;;
}


dimension: latitude {
  type: number
  sql: ${TABLE}.latitude ;;
}

dimension: longitude {
  type: number
  sql: ${TABLE}.longitude ;;
}

dimension: state {
  type: string
  sql: ${TABLE}.state ;;
  map_layer_name: us_states
}

dimension: traffic_source {
  type: string
  sql: ${TABLE}.traffic_source ;;
}


  dimension: is_email_source {

    type: yesno

    sql: ${traffic_source} = "Email" ;;

  }

dimension: zips {
  type: zipcode
  sql: ${TABLE}.zip ;;
}

  dimension: full_name {

    type: string

    sql: concat(${first_name},"  ", ${last_name}) ;;

  }


measure: count {
  type: count
  drill_fields: [id, last_name, first_name, events.count, order_items.count]
}
}
