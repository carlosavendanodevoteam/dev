# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker.order_items` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.
  parameter: filtro_transportista {
    type: unquoted
    allowed_value: {
      label: "Transportistas desagrupados"
      value: "desagrupados"
    }
    allowed_value: {
      label: "Transportistas Agrupados"
      value: "agrupados"
    }
  }
  dimension: dynamic_transportista {
    sql:
          {% if filtro_transportista._parameter_value == 'desagrupados' %}
             "desagrupados"
          {% elsif filtro_transportista._parameter_value == 'agrupados' %}
           "agrupados"
             {% else %}
          "agrupados"
          {% endif %};;
  }

  dimension: dynamic_date_1 {
    sql:  ${filter_start_date_1_date};;
    html:{{ rendered_value | date: "Fecha elegida 1: %Y-%m-%d"}};;

  }

  dimension: dynamic_date_2 {
    sql:  ${filter_start_date_2_date};;
    html:{{ rendered_value | date: "Fecha elegida 2: %Y-%m-%d" }};;

  }

  dimension: dynamic_date_diference {
    sql: CONCAT('Diferencia entre ', ${filter_start_date_1_date}, ' y ', ${filter_start_date_2_date}) ;;
    html: {{value}} ;;
  }

  filter: date_filter_1 {
    description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
    type: date
  }

  filter: date_filter_2 {
    description: "Use this date filter in combination with the timeframes dimension for dynamic date filtering"
    type: date
  }

  dimension_group: filter_start_date_1 {
    type: time
    timeframes: [raw,date]
    sql: CASE WHEN {% date_start date_filter_1 %} IS NULL THEN CURRENT_DATE ELSE CAST({% date_start date_filter_1 %} AS DATE) END;;
  }


  dimension_group: filter_start_date_2 {
    type: time
    timeframes: [raw,date]
    sql: CASE WHEN {% date_start date_filter_2 %} IS NULL THEN CURRENT_DATE ELSE CAST({% date_start date_filter_2 %} AS DATE) END;;
  }


  dimension: is_current_period_1 {
    type: yesno
    sql: ${created_date} = ${filter_start_date_1_date} ;;
  }
  dimension: is_current_period_2 {
    type: yesno
    sql: ${created_date} = ${filter_start_date_2_date} ;;
  }

  measure: total_sales_1 {

    type: sum

    sql: ${sale_price} ;;
    filters: {
      field: is_current_period_1
      value: "yes"
    }

    value_format_name: usd_0

  }
  measure: total_sales_2 {

    type: sum

    sql: ${sale_price} ;;
    filters: {
      field: is_current_period_2
      value: "yes"
    }

    value_format_name: usd_0

  }

  measure: total_sales_diferencia {

    type: number

    sql: ${total_sales_1}-${total_sales_2};;

    value_format_name: usd_0

  }

dimension: order_item_id {
  primary_key: yes
  # No primary ke
  type: number
  sql: ${TABLE}.id ;;
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

dimension_group: delivered {
  type: time
  timeframes: [
    raw,
    date,
    week,
    month,
    quarter,
    year
  ]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.delivered_at ;;
}

dimension: inventory_item_id {
  type: number
  # hidden: yes
  sql: ${TABLE}.inventory_item_id ;;
}

dimension: order_id {
  type: number
  sql: ${TABLE}.order_id ;;
}

dimension_group: returned {
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
  sql: ${TABLE}.returned_at ;;
}


dimension: sale_price {
  type: number
  sql: ${TABLE}.sale_price ;;
}


  measure: percent_revenue_email_source {

    type: number

    value_format_name: percent_2

    sql: 1.0*${total_revenue_email_users}

        /NULLIF(${total_revenue}, 0) ;;

  }




  measure: total_revenue_email_users {

    type: sum

    sql: ${sale_price} ;;

    filters: [users.is_email_source: "Yes"]

    value_format_name: usd

  }




  measure: total_sales {

    type: sum

    sql: ${sale_price} ;;

    value_format_name: usd_0

  }



dimension_group: shipped {
  type: time
  timeframes: [
    raw,
    date,
    week,
    month,
    quarter,
    year
  ]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.shipped_at ;;
}

dimension: status {
  type: string
  sql: ${TABLE}.status ;;
}

dimension: user_id {
  type: number
  # hidden: yes
  sql: ${TABLE}.user_id ;;
}

measure: order_item_count {
  type: count
  drill_fields: [detail*]
}

measure: order_count {
  type: count_distinct
  sql: ${order_id} ;;
}

measure: total_revenue {
  type: sum
  sql: ${sale_price} ;;
  value_format_name: usd
}

measure: total_revenue_from_completed_orders {
  type: sum
  sql: ${sale_price} ;;
  filters: [status: "Complete"]
  value_format_name: usd
}



# ----- Sets of fields for drilling ------
set: detail {
  fields: [
    order_item_id,
    users.last_name,
    users.id,
    users.first_name,
    inventory_items.id,
    inventory_items.product_name
  ]
}
}
