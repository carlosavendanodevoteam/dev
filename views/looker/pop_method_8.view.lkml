# The name of this view in Looker is "Order Items"
view: pop_method_8 {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: (SELECT NULL) ;;
  # view_label: "_PoP"

  ### ------------ (HIDDEN) FILTERS TO CUSTOMIZE THE APPROACH ------------


  # Choose a date range to filter on
  filter: date_filter  {
    label: "1. Date Range"
    hidden: yes
    type: date
    convert_tz: no
  }

  # A second filter to choose number of past periods. Defaults to 1 if this is not selected
  filter: over_how_many_past_periods {
    label: "Override past periods"
    description: "Apply this filter to add past periods to compare to (from the default of current vs 1 period ago)"
    type: number
    default_value: "<=1"
  }


  # Choose how to break the range down - normally done with a parameter but here is a dimension
  dimension: within_period_type {
    label: "2. Break down date range by"
    hidden: yes
    type: string
    #Using case just to get friendlier UI experience in filters. Otherwise, could have a no-sql filter field
    case: {
      when: {
        sql: {% parameter pop_method_8.within_period_type %}='quarter' ;;
        label: "quarter"
      }
      when: {
        sql: {% parameter pop_method_8.within_period_type %}='month' ;;
        label: "month"
      }
      when: {
        sql: {% parameter pop_method_8.within_period_type %}='week' ;;
        label: "week"
      }
      when: {
        sql: {% parameter pop_method_8.within_period_type %}='day' ;;
        label: "day"
      }
      when: {
        sql: {% parameter pop_method_8.within_period_type %}='hour' ;;
        label: "hour"
      }
    }
  }



  # Choose the previous period
  # Again we use a dimension here instead of a parameter
  dimension: over_period_type {
    label: "3. Compare over"
    hidden: yes
    type: string
    #Using case just to get friendlier UI experience in filters. Otherwise, could have a no-sql filter field
    case: {
      when: {
        sql: {% parameter pop_method_8.over_period_type %}='year' ;;
        label: "year"
      }
      when: {
        sql: {% parameter pop_method_8.over_period_type %}='quarter' ;;
        label: "quarter"
      }
      when: {
        sql: {% parameter pop_method_8.over_period_type %}='month' ;;
        label: "month"
      }
      when: {
        sql: {% parameter pop_method_8.over_period_type %}='week' ;;
        label: "week"
      }
      when: {
        sql: {% parameter pop_method_8.over_period_type %}='day' ;;
        label: "day"
      }
    }
  }

  ### ------------ DIMENSIONS WE WILL ACTUALLY PLOT ------------

  # This is the dimension we will plot as rows
  # This version is always ordered correctly
  dimension: reference_date {
    hidden: yes
    sql:
    CASE
      WHEN {% parameter pop_method_8.within_period_type %} = 'hour' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(
            TIMESTAMP({% date_end pop_method_8.date_filter %}),
            INTERVAL (-((${within_periods.n} + 1))) HOUR
          ),
          HOUR
        ))
      WHEN {% parameter pop_method_8.within_period_type %} = 'day' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(
            DATE({% date_end pop_method_8.date_filter %}),
            INTERVAL (-((${within_periods.n} + 1))) DAY
          ),
          DAY
        ))
      WHEN {% parameter pop_method_8.within_period_type %} = 'week' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(
            DATE({% date_end pop_method_8.date_filter %}),
            INTERVAL (-((${within_periods.n} + 1))) WEEK
          ),
          WEEK
        ))
      WHEN {% parameter pop_method_8.within_period_type %} = 'month' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(
            DATE({% date_end pop_method_8.date_filter %}),
            INTERVAL (-((${within_periods.n} + 1))) MONTH
          ),
          MONTH
        ))
      WHEN {% parameter pop_method_8.within_period_type %} = 'quarter' THEN
        DATE(DATE_TRUNC(
          DATE_ADD(
            DATE({% date_end pop_method_8.date_filter %}),
            INTERVAL (-((${within_periods.n} + 1))) QUARTER
          ),
          QUARTER
        ))
      ELSE
        DATE(DATE_TRUNC(
          DATE_ADD(
            DATE({% date_end pop_method_8.date_filter %}),
            INTERVAL (-((${within_periods.n} + 1))) DAY
          ),
          DAY
        ))
    END ;;
  }




  # This is the version we will actually plot in the data with nice formatting
  dimension: reference_date_formatted {
    type: string
    order_by_field: reference_date
    label: "Reference date"
    sql:  FORMAT_DATE(
      CASE {% parameter pop_method_8.within_period_type %}
        WHEN 'year' THEN '%Y'
        WHEN 'month' THEN '%b %y'
        WHEN 'quarter' THEN '%Y"Q"Q'
        WHEN 'week' THEN '%m/%d/%y'  -- or '%Y"W"WW' or '%y-%m"W"WW'
        WHEN 'day' THEN '%m/%d/%y'
        WHEN 'hour' THEN '%m/%d %H%p'
        ELSE '%m/%d/%y'
      END,
        ${reference_date})
        ;;}


  # This is the dimension we will plot as pivots
  dimension: over_periods_ago  {
    label: "Prior Periods"
    description: "Pivot me!"
    sql: CASE ${over_periods.n}
                    WHEN 0 THEN 'Current '||{% parameter pop_method_8.over_period_type %}
                    WHEN 1 THEN ${over_periods.n}||' '||{% parameter pop_method_8.over_period_type %} || ' prior'
                    ELSE        ${over_periods.n}||' '||{% parameter pop_method_8.over_period_type %} || 's prior'
                    END;;
    order_by_field: over_periods.n
  }
}
