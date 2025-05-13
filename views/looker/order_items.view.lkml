# The name of this view in Looker is "Order Items"


view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker.order_items_extended` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.


# TEST DIGLO 2

  parameter: choose_breakdown {
    label: "Choose Grouping (Rows)"
    view_label: "_PoP"
    type: unquoted
    default_value: "Month"
    allowed_value: {label: "Month Name" value:"Month"}
    allowed_value: {label: "Day of Year" value: "DOY"}
    allowed_value: {label: "Day of Month" value: "DOM"}
    allowed_value: {label: "Day of Week" value: "DOW"}
    allowed_value: {label: "Week" value: "Week"}
    allowed_value: {value: "Date"}
  }


  parameter: choose_comparison {
    label: "Choose Comparison (Pivot)"
    view_label: "_PoP"
    type: unquoted
    default_value: "Year"
    allowed_value: {value: "Year" }
    allowed_value: {value: "Month"}
    allowed_value: {value: "Week"}
  }


  dimension: pop_row  {
    view_label: "_PoP"
    label_from_parameter: choose_breakdown
    type: string
    order_by_field: sort_by1 # Important
    sql:
        {% if choose_breakdown._parameter_value == 'Month' %} ${created_month_name}
        {% elsif choose_breakdown._parameter_value == 'DOY' %} ${created_day_of_year}
        {% elsif choose_breakdown._parameter_value == 'DOM' %} ${created_day_of_month}
        {% elsif choose_breakdown._parameter_value == 'DOW' %} ${created_day_of_week}
        {% elsif choose_breakdown._parameter_value == 'Date' %} ${created_date}
        {% elsif choose_breakdown._parameter_value == 'Week' %} ${created_week}
        {% else %}NULL{% endif %} ;;
  }

  dimension: pop_pivot {
    view_label: "_PoP"
    label_from_parameter: choose_comparison
    type: string
    order_by_field: sort_by2 # Important
    sql:
        {% if choose_comparison._parameter_value == 'Year' %} ${created_year}
        {% elsif choose_comparison._parameter_value == 'Month' %} ${created_month_name}
        {% elsif choose_comparison._parameter_value == 'Week' %} ${created_week}
        {% else %}NULL{% endif %} ;;
  }


# These dimensions are just to make sure the dimensions sort correctly

  dimension: sort_by1 {
    hidden: yes
    type: number
    sql:
        {% if choose_breakdown._parameter_value == 'Month' %} ${created_month_num}
        {% elsif choose_breakdown._parameter_value == 'DOY' %} ${created_day_of_year}
        {% elsif choose_breakdown._parameter_value == 'DOM' %} ${created_day_of_month}
       {% elsif choose_breakdown._parameter_value == 'DOW' %} ${created_day_of_week_index}
        {% elsif choose_breakdown._parameter_value == 'Date' %} ${created_date}
       {% else %}NULL{% endif %} ;;
  }

  dimension: sort_by2 {
    hidden: yes
    type: string
    sql:
        {% if choose_comparison._parameter_value == 'Year' %} ${created_year}
        {% elsif choose_comparison._parameter_value == 'Month' %} ${created_month_num}
       {% elsif choose_comparison._parameter_value == 'Week' %} ${created_week}
        {% else %}NULL{% endif %} ;;
  }


  parameter: comparison_periods {
    view_label: "_PoP"
    label: " Number of Periods"
    description: "Choose the number of periods you would like to compare."
    type: unquoted
    allowed_value: {
      label: "2"
      value: "2"
    }
    allowed_value: {
      label: "3"
      value: "3"
    }
    allowed_value: {
      label: "4"
      value: "4"
    }
    default_value: "2"
  }

  parameter: compare_to {
    view_label: "_PoP"
    description: "Select the templated previous period you would like to compare to. Must be used with Current Date Range filter"
    label: "2. Compare To:"
    type: unquoted
    allowed_value: {
      label: "Previous Period"
      value: "Period"
    }
    allowed_value: {
      label: "Previous Week"
      value: "Week"
    }
    allowed_value: {
      label: "Previous Month"
      value: "Month"
    }
    allowed_value: {
      label: "Previous Quarter"
      value: "Quarter"
    }
    allowed_value: {
      label: "Previous Year"
      value: "Year"
    }
    default_value: "Period"
  }

  filter: current_date_range {
    type: date
    view_label: "_PoP"
    label: "1. Current Date Range"
    description: "Select the current date range you are interested in. Make sure any other filter on Event Date covers this period, or is removed."
    sql: ${period} IS NOT NULL ;;
  }

  dimension: days_in_period {
    hidden:  yes
    view_label: "_PoP"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATEDIFF(DAY, DATE({% date_start current_date_range %}), DATE({% date_end current_date_range %})) ;;
  }

  dimension: period_2_start {
    hidden:  yes
    view_label: "_PoP"
    description: "Calculates the start of the previous period"
    type: date
    sql:
            {% if compare_to._parameter_value == "Period" %}
            DATEADD(DAY, -${days_in_period}, DATE({% date_start current_date_range %}))
            {% else %}
            DATEADD({% parameter compare_to %}, -1, DATE({% date_start current_date_range %}))
            {% endif %};;
  }

  dimension: period_2_end {
    hidden:  yes
    view_label: "_PoP"
    description: "Calculates the end of the previous period"
    type: date
    sql:
            {% if compare_to._parameter_value == "Period" %}
            DATEADD(DAY, -1, DATE({% date_start current_date_range %}))
            {% else %}
            DATEADD({% parameter compare_to %}, -1, DATEADD(DAY, -1, DATE({% date_end current_date_range %})))
            {% endif %};;
  }

  dimension: period_3_start {
    view_label: "_PoP"
    description: "Calculates the start of 2 periods ago"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
            DATEADD(DAY, -(2 * ${days_in_period}), DATE({% date_start current_date_range %}))
        {% else %}
            DATEADD({% parameter compare_to %}, -2, DATE({% date_start current_date_range %}))
        {% endif %};;
    hidden: yes

  }

  dimension: period_3_end {
    view_label: "_PoP"
    description: "Calculates the end of 2 periods ago"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
            DATEADD(DAY, -1, ${period_2_start})
        {% else %}
            DATEADD({% parameter compare_to %}, -2, DATEADD(DAY, -1, DATE({% date_end current_date_range %})))
        {% endif %};;
    hidden: yes
  }

  dimension: period_4_start {
    view_label: "_PoP"
    description: "Calculates the start of 4 periods ago"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
            DATEADD(DAY, -(3 * ${days_in_period}), DATE({% date_start current_date_range %}))
        {% else %}
            DATEADD({% parameter compare_to %}, -3, DATE({% date_start current_date_range %}))
        {% endif %};;
    hidden: yes
  }

  dimension: period_4_end {
    view_label: "_PoP"
    description: "Calculates the end of 4 periods ago"
    type: date
    sql:
            {% if compare_to._parameter_value == "Period" %}
            DATEADD(DAY, -1, ${period_2_start})
            {% else %}
            DATEADD({% parameter compare_to %}, -3, DATEADD(DAY, -1, DATE({% date_end current_date_range %})))
            {% endif %};;
    hidden: yes
  }


  dimension: period {
    view_label: "_PoP"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period', 'Previous Period' or '3 Periods Ago'"
    type: string
    order_by_field: order_for_period
    sql:
            {% if current_date_range._is_filtered %}
                CASE
                WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
                THEN 'This {% parameter compare_to %}'
                WHEN ${created_date} between ${period_2_start} and ${period_2_end}
                THEN 'Last {% parameter compare_to %}'
                WHEN ${created_date} between ${period_3_start} and ${period_3_end}
                THEN '2 {% parameter compare_to %}s Ago'
                WHEN ${created_date} between ${period_4_start} and ${period_4_end}
                THEN '3 {% parameter compare_to %}s Ago'
                END
            {% else %}
                NULL
            {% endif %}
            ;;
  }



  dimension: order_for_period {
    hidden: yes
    view_label: "Comparison Fields"
    label: "Period"
    type: string
    sql:
            {% if current_date_range._is_filtered %}
                CASE
                WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
                THEN 1
                WHEN ${created_date} between ${period_2_start} and ${period_2_end}
                THEN 2
                WHEN ${created_date} between ${period_3_start} and ${period_3_end}
                THEN 3
                WHEN ${created_date} between ${period_4_start} and ${period_4_end}
                THEN 4
                END
            {% else %}
                NULL
            {% endif %}
            ;;
  }

  dimension: day_in_period {
    description: "Gives the number of days since the start of each periods. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
            THEN DATEDIFF(DAY, DATE({% date_start current_date_range %}), ${created_date}) + 1

      WHEN ${created_date} between ${period_2_start} and ${period_2_end}
      THEN DATEDIFF(DAY, ${period_2_start}, ${created_date}) + 1

      WHEN ${created_date} between ${period_3_start} and ${period_3_end}
      THEN DATEDIFF(DAY, ${period_3_start}, ${created_date}) + 1

      WHEN ${created_date} between ${period_4_start} and ${period_4_end}
      THEN DATEDIFF(DAY, ${period_4_start}, ${created_date}) + 1
      END

      {% else %} NULL
      {% endif %}
      ;;
    hidden: yes
  }





























# TEST DIGLO 2 END


# TEST DIGLO
  parameter: selected_date {
    type: date
    description: "Selecciona un día de referencia"
  }

  parameter: num_years {
    type: number
    description: "Cantidad de años hacia atrás a comparar"
    default_value: "3"
  }



 dimension: in_selected_range {
  type: yesno
  sql: DATE(${created_date}) BETWEEN DATE_TRUNC(CAST({% parameter selected_date %} AS DATE), YEAR)
    AND CAST({% parameter selected_date %} AS DATE) ;;
}

dimension: in_last_n_years {
  type: yesno
  sql: EXTRACT(YEAR FROM ${created_date}) BETWEEN EXTRACT(YEAR FROM CAST({% parameter selected_date %} AS DATE)) - ({% parameter num_years %} - 1)
    AND EXTRACT(YEAR FROM CAST({% parameter selected_date %} AS DATE)) ;;
}

measure: total_sales_filtered {
  type: sum
  sql: CASE
         WHEN ${in_selected_range} AND ${in_last_n_years} THEN ${sale_price}
         ELSE 0
       END ;;
  value_format_name: usd_0
}






  # TEST DIGLO END









  parameter: selected_month {
    type: string
    allowed_value: {
      label: "January"
      value: "01"
    }
    allowed_value: {
      label: "February"
      value: "02"
    }
    allowed_value: {
      label: "March"
      value: "03"
    }
    # Agrega el resto de los meses...
  }

  parameter: filter_type {
    type: string
    allowed_value: {
      label: "Solo ese mes"
      value: "month"
    }
    allowed_value: {
      label: "Desde el 1 de enero hasta ese mes"
      value: "year_to_month"
    }
  }

  dimension: temporal_filter {
    type: yesno
    sql:
    CASE
      WHEN {% parameter filter_type %} = 'month' THEN
        DATE_TRUNC(${created_date}, MONTH) = DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()), '-', {% parameter selected_month %}, '-01'))
      WHEN {% parameter filter_type %} = 'year_to_month' THEN
        DATE(${created_date}) BETWEEN DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()), '-01-01'))
                                 AND LAST_DAY(DATE(CONCAT(EXTRACT(YEAR FROM CURRENT_DATE()), '-', {% parameter selected_month %}, '-01')))
      ELSE NULL
    END ;;
  }


  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.
  parameter: filtro_transportista {
    required_access_grants: [access_test]
    type: unquoted
    allowed_value: {
      label: "Titulo 1"
      value: "desagrupados"
    }
    allowed_value: {
      label: "Titulo 2"
      value: "agrupados"
    }
  }
  dimension: dynamic_transportista {
    sql:
          {% if filtro_transportista._parameter_value == 'desagrupados' %}
             "Ejemplo 1"
          {% elsif filtro_transportista._parameter_value == 'agrupados' %}
           "Ejemplo dos"
             {% else %}
          "Ejemplo 1"
          {% endif %};;
  }

  dimension: dynamic_fecha {
    sql:
concat("fecha elegida ",CAST({% date_start date_filter_1 %} AS DATE));;
  }

  dimension: dynamic_fecha_2 {
    sql:
    concat("fecha elegida ",CAST({% date_start date_filter_2 %} AS DATE));;
  }

  dimension: dynamic_comparativa{
    sql:
    concat("comparacion entre ",CAST({% date_start date_filter_1 %} AS DATE)," y ",CAST({% date_start date_filter_2 %} AS DATE));;
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
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
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
  required_access_grants: [access_test]
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

  measure: total_sales_last_year {
    type: period_over_period
    based_on: total_sales
    based_on_time: created_year
    period: year
    kind: previous
  }

  measure: total_sales_last_month {
    type: period_over_period
    based_on: total_sales
    based_on_time: created_year
    period: month
    kind: previous
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

parameter: fecha {
  type: date
}

dimension: year_to_date {
  type:  yesno
  sql: DATE(${created_date}) BETWEEN DATE(CONCAT(EXTRACT(YEAR FROM {%parameter fecha%}), '-01-01')) AND DATE({%parameter fecha%})  ;;
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
