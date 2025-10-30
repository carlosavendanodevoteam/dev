# The name of this view in Looker is "Events"
view: events {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker.events` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Browser" in Explore.




  dimension: test{
    type: number
    sql: (SELECT id FROM `carlos-avendano-sandbox.looker.events`)  ;;
  }


 dimension: id {
  primary_key: yes
  type: number
  sql: ${TABLE}.id ;;
}

dimension: ad_event_id {
  type: number
  # hidden: yes
  sql: ${TABLE}.ad_event_id ;;
}

dimension: browser {
  type: string
  sql: ${TABLE}.browser ;;
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

dimension: event_type {
  type: string
  sql: ${TABLE}.event_type ;;
}

dimension: ip_address {
  type: string
  sql: ${TABLE}.ip_address ;;
}

dimension: latitude {
  type: number
  sql: ${TABLE}.latitude ;;
}

dimension: longitude {
  type: number
  sql: ${TABLE}.longitude ;;
}

dimension: os {
  type: string
  sql: ${TABLE}.os ;;
}

dimension: referrer_code {
  type: string
  sql: ${TABLE}.referrer_code ;;
}

dimension: sequence_number {
  type: number
  sql: ${TABLE}.sequence_number ;;
}

dimension: session_id {
  type: string
  sql: ${TABLE}.session_id ;;
}

dimension: state {
  type: string
  sql: ${TABLE}.state ;;
}

dimension: traffic_source {
  type: string
  sql: ${TABLE}.traffic_source ;;
}

dimension: uri {
  type: string
  sql: ${TABLE}.uri ;;
}

dimension: user_id {
  type: number
  # hidden: yes
  sql: ${TABLE}.user_id ;;
}

dimension: zip {
  type: zipcode
  sql: ${TABLE}.zip ;;
}

measure: count {
  type: count
  drill_fields: [id, ad_events.id, users.last_name, users.id, users.first_name]
}
}
