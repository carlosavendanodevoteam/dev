view: bq_queries {
  derived_table: {
    sql: SELECT
  j.*,
  u.value AS user_id
FROM
  region-us.INFORMATION_SCHEMA.JOBS j,
  UNNEST(j.labels) AS u
WHERE
  u.key = "looker-context-user_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: creation_time {
    type: time
    sql: ${TABLE}.creation_time ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }


  dimension: project_id {
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: project_number {
    type: number
    sql: ${TABLE}.project_number ;;
  }

  dimension: user_email {
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension: principal_subject {
    type: string
    sql: ${TABLE}.principal_subject ;;
  }

  dimension: job_id {
    type: string
    sql: ${TABLE}.job_id ;;
  }

  dimension: job_type {
    type: string
    sql: ${TABLE}.job_type ;;
  }

  dimension: statement_type {
    type: string
    sql: ${TABLE}.statement_type ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.priority ;;
  }

  dimension_group: start_time {
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
    sql: ${TABLE}.start_time ;;
  }

  dimension_group: end_time {
    type: time
    sql: ${TABLE}.end_time ;;
  }

  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: reservation_id {
    type: string
    sql: ${TABLE}.reservation_id ;;
  }

  dimension: total_bytes_processed {
    type: number
    sql: ${TABLE}.total_bytes_processed ;;
  }

  dimension: total_MB {
    type: number
    sql: ${TABLE}.total_bytes_processed/1000000  ;;
  }

  dimension: coste_dollar {
    type: number
    sql: (${TABLE}.total_bytes_processed/1000000000000)*7.5  ;;
  }

  dimension: total_slot_ms {
    type: number
    sql: ${TABLE}.total_slot_ms ;;
  }

  dimension: total_services_sku_slot_ms {
    type: number
    sql: ${TABLE}.total_services_sku_slot_ms ;;
  }

  dimension: error_result {
    type: string
    sql: ${TABLE}.error_result ;;
  }

  dimension: cache_hit {
    type: yesno
    sql: ${TABLE}.cache_hit ;;
  }

  dimension: destination_table {
    type: string
    sql: ${TABLE}.destination_table ;;
  }

  dimension: referenced_tables {
    type: string
    sql: ${TABLE}.referenced_tables ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: timeline {
    type: string
    sql: ${TABLE}.timeline ;;
  }

  dimension: job_stages {
    type: string
    sql: ${TABLE}.job_stages ;;
  }

  dimension: total_bytes_billed {
    type: number
    sql: ${TABLE}.total_bytes_billed ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: parent_job_id {
    type: string
    sql: ${TABLE}.parent_job_id ;;
  }

  dimension: session_info {
    type: string
    sql: ${TABLE}.session_info ;;
  }

  dimension: dml_statistics {
    type: string
    sql: ${TABLE}.dml_statistics ;;
  }

  dimension: total_modified_partitions {
    type: number
    sql: ${TABLE}.total_modified_partitions ;;
  }

  dimension: bi_engine_statistics {
    type: string
    sql: ${TABLE}.bi_engine_statistics ;;
  }

  dimension: query_info {
    type: string
    sql: ${TABLE}.query_info ;;
  }

  dimension: transferred_bytes {
    type: number
    sql: ${TABLE}.transferred_bytes ;;
  }

  dimension: materialized_view_statistics {
    type: string
    sql: ${TABLE}.materialized_view_statistics ;;
  }

  dimension: edition {
    type: string
    sql: ${TABLE}.edition ;;
  }

  dimension: job_creation_reason {
    type: string
    sql: ${TABLE}.job_creation_reason ;;
  }

  dimension: continuous_query_info {
    type: string
    sql: ${TABLE}.continuous_query_info ;;
  }

  dimension: continuous {
    type: yesno
    sql: ${TABLE}.continuous ;;
  }

  dimension: query_dialect {
    type: string
    sql: ${TABLE}.query_dialect ;;
  }

  dimension: metadata_cache_statistics {
    type: string
    sql: ${TABLE}.metadata_cache_statistics ;;
  }

  dimension: search_statistics {
    type: string
    sql: ${TABLE}.search_statistics ;;
  }

  dimension: vector_search_statistics {
    type: string
    sql: ${TABLE}.vector_search_statistics ;;
  }

  set: detail {
    fields: [
      creation_time_time,
      project_id,
      project_number,
      user_email,
      principal_subject,
      job_id,
      job_type,
      statement_type,
      priority,
      start_time_time,
      end_time_time,
      query,
      state,
      reservation_id,
      total_bytes_processed,
      total_slot_ms,
      total_services_sku_slot_ms,
      error_result,
      cache_hit,
      destination_table,
      referenced_tables,
      labels,
      timeline,
      job_stages,
      total_bytes_billed,
      transaction_id,
      parent_job_id,
      session_info,
      dml_statistics,
      total_modified_partitions,
      bi_engine_statistics,
      query_info,
      transferred_bytes,
      materialized_view_statistics,
      edition,
      job_creation_reason,
      continuous_query_info,
      continuous,
      query_dialect,
      metadata_cache_statistics,
      search_statistics,
      vector_search_statistics
    ]
  }
}
