view: order_items_test_manu {
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
    required_access_grants: [access_test_rsi]
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
  } dimension_group: shipped {
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
  }


  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  dimension: created_month_of_quarter_advanced {
    label: "Orders Month of Quarter"
    group_label: "Orders Dates"
    group_item_label: "Month of Quarter"
    type: number
    sql:
      case
        when ${order_items_test_manu.created_month_num} IN (1,4,7,10) THEN 1
        when ${order_items_test_manu.created_month_num} IN (2,5,8,11) THEN 2
        else 3
      end
    ;;
  }

  dimension: is_to_date_advanced {
    hidden: yes
    type: yesno
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == 'ytd' %}true
      {% else %}
        {% if parameters.apply_to_date_filter_advanced._parameter_value == 'true' %}
          {% if parameters.select_timeframe_advanced._parameter_value == 'week' %}
            ${order_items_test_manu.created_day_of_week_index} <= ${parameters.current_timestamp_advanced_day_of_week_index}
          {% elsif parameters.select_timeframe_advanced._parameter_value == 'day' %}
            ${order_items_test_manu.created_hour_of_day} <= ${parameters.current_timestamp_advanced_hour_of_day}
          {% elsif parameters.select_dynamic_timeframe_advanced._parameter_value == 'quarter' %}
            ${order_items_test_manu.created_month_of_quarter_advanced} <= ${parameters.current_timestamp_month_of_quarter_advanced}
          {% elsif parameters.select_timeframe_advanced._parameter_value == 'year' %}
            ${order_items_test_manu.created_day_of_year} <= ${parameters.current_timestamp_advanced_day_of_year}
          {% else %}
            ${order_items_test_manu.created_day_of_month} <= ${parameters.current_timestamp_advanced_day_of_month}
          {% endif %}
        {% else %} true
        {% endif %}
      {% endif %}
    ;;
  }

  dimension: selected_dynamic_timeframe_advanced  {
    label_from_parameter: parameters.select_timeframe_advanced
    type: string
    hidden: yes
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == 'day' %}
        ${order_items_test_manu.created_date}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'week' %}
        ${order_items_test_manu.created_week}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'year' %}
        ${order_items_test_manu.created_year}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'quarter' %}
        ${order_items_test_manu.created_quarter}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'ytd' %}
        CONCAT('YTD (',${order_items_test_manu.created_year},'-',${parameters.selected_reference_date_default_today_advanced_month_num},'-',${parameters.selected_reference_date_default_today_advanced_day_of_month},')')
      {% else %}
        ${order_items_test_manu.created_month}
      {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of_advanced  {
    label: "{%
    if parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'month' %}Day of Month{%
    elsif parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'week' %}Day of Week{%
    elsif parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'day' %}Hour of Day{%
    elsif parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'year' %}Months{%
    elsif parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'ytd' %}Day of Year{%
    else %}Selected Dynamic Timeframe Granularity{%
    endif %}"
    order_by_field: order_items_test_manu.selected_dynamic_day_of_sort_advanced
    type: string
    sql:
    {% if parameters.select_timeframe_advanced._parameter_value == 'day' %}
      ${order_items_test_manu.created_hour_of_day}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'week' %}
      ${order_items_test_manu.created_day_of_week}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'year' %}
      ${order_items_test_manu.created_month_name}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'quarter' %}
      ${order_items_test_manu.created_month_of_quarter_advanced}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'ytd' %}
      ${order_items_test_manu.created_day_of_year}
    {% else %}
      ${order_items_test_manu.created_day_of_month}
    {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of_sort_advanced  {
    hidden: yes
    label_from_parameter: parameters.select_timeframe_advanced
    type: number
    sql:
    {% if parameters.select_timeframe_advanced._parameter_value == 'day' %}
      ${order_items_test_manu.created_hour_of_day}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'week' %}
      ${order_items_test_manu.created_day_of_week_index}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'year' %}
      ${order_items_test_manu.created_month_num}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'quarter' %}
      ${order_items_test_manu.created_month_of_quarter_advanced}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'ytd' %}
      ${order_items_test_manu.created_day_of_year}
    {% else %}
      ${order_items_test_manu.created_day_of_month}
    {% endif %}
    ;;
  }

  }
