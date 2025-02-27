view: pop {
  sql_table_name: (SELECT NULL) ;;
  view_label: "_PoP"

  ### ------------ (HIDDEN) FILTERS TO CUSTOMIZE THE APPROACH ------------

  filter: date_filter {
    label: "1. Date Range"
    hidden: yes
    type: date
    convert_tz: no
  }

  filter: over_how_many_past_periods {
    label: "Override past periods"
    description: "Apply this filter to add past periods to compare to (from the default of current vs 1 period ago)"
    type: number
    default_value: "<=1"
  }

  dimension: within_period_type {
    label: "2. Break down date range by"
    hidden: yes
    type: string
    case: {
      when: { sql: {% parameter pop.within_period_type %} = 'quarter' ;; label: "QUARTER" }
      when: { sql: {% parameter pop.within_period_type %} = 'month' ;; label: "MONTH" }
      when: { sql: {% parameter pop.within_period_type %} = 'week' ;; label: "WEEK" }
      when: { sql: {% parameter pop.within_period_type %} = 'day' ;; label: "DAY" }
      when: { sql: {% parameter pop.within_period_type %} = 'hour' ;; label: "HOUR" }
    }
  }

  dimension: over_period_type {
    label: "3. Compare over"
    hidden: yes
    type: string
    case: {
      when: { sql: {% parameter pop.over_period_type %} = 'year' ;; label: "YEAR" }
      when: { sql: {% parameter pop.over_period_type %} = 'quarter' ;; label: "QUARTER" }
      when: { sql: {% parameter pop.over_period_type %} = 'month' ;; label: "MONTH" }
      when: { sql: {% parameter pop.over_period_type %} = 'week' ;; label: "WEEK" }
      when: { sql: {% parameter pop.over_period_type %} = 'day' ;; label: "DAY" }
    }
  }

  ### ------------ DIMENSIONS WE WILL ACTUALLY PLOT ------------

  dimension: reference_date {
    hidden: yes
    sql: DATE_TRUNC(
      DATE_ADD({% date_end pop.date_filter %}, INTERVAL -(${within_periods.n} + 1) {% parameter pop.within_period_type %}),
      {% parameter pop.within_period_type %}
    ) ;;
  }

  dimension: reference_date_formatted {
    type: string
    order_by_field: reference_date
    label: "Reference date"
    sql: TO_CHAR(
      ${reference_date},
      CASE
        WHEN {% parameter pop.within_period_type %} = 'year' THEN 'YYYY'
        WHEN {% parameter pop.within_period_type %} = 'month' THEN 'MON YY'
        WHEN {% parameter pop.within_period_type %} = 'quarter' THEN 'YYYY"Q"Q'
        WHEN {% parameter pop.within_period_type %} = 'week' THEN 'MM/DD/YY'
        WHEN {% parameter pop.within_period_type %} = 'day' THEN 'MM/DD/YY'
        WHEN {% parameter pop.within_period_type %} = 'hour' THEN 'MM/DD HH24:MI'
        ELSE 'MM/DD/YY'
      END
    ) ;;
  }

  dimension: over_periods_ago {
    label: "Prior Periods"
    description: "Pivot me!"
    sql: CASE
          WHEN ${over_periods.n} = 0 THEN 'Current ' || CAST({% parameter pop.over_period_type %} AS STRING)
          WHEN ${over_periods.n} = 1 THEN CAST(${over_periods.n} AS STRING) || ' ' || CAST({% parameter pop.over_period_type %} AS STRING) || ' prior'
          ELSE CAST(${over_periods.n} AS STRING) || ' ' || CAST({% parameter pop.over_period_type %} AS STRING) || 's prior'
       END ;;
    order_by_field: over_periods.n
  }
}
