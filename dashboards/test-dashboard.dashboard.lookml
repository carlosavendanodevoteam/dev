---
- dashboard: testdashboardlookml
  title: test-dashboard-lookml
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: gEmcYAqMUxhFK2EZ7pc2pt
  elements:
  - title: Untitled
    name: Untitled
    model: carlos-training-looker
    explore: order_items
    type: looker_bar
    fields: [users.age, products.count, users.gender]
    pivots: [users.gender]
    sorts: [users.gender, products.count desc 0]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Gender: users.gender
    row: 0
    col: 0
    width: 14
    height: 8
  - name: add_a_unique_name_1746689123
    title: Untitled Visualization
    model: carlos-training-looker
    explore: order_items
    type: table
    fields: [order_items.user_id, order_items.order_count]
    limit: 500

  filters:
  - name: Gender
    title: Gender
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    model: carlos-training-looker
    explore: order_items
    listens_to_filters: []
    field: users.gender
