# The name of this view in Looker is "Inventory Items"
view: inventory_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker.inventory_items` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Cost" in Explore.

dimension: id {
  primary_key: yes
  type: number
  sql: ${TABLE}.id ;;
}

dimension: cost {
  type: number
  sql: ${TABLE}.cost ;;
}

dimension_group: created {
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
  sql: ${TABLE}.created_at ;;
}

dimension: product_brand {
  type: string
  sql: ${TABLE}.product_brand ;;
}

dimension: product_category {
  type: string
  sql: ${TABLE}.product_category ;;
}

dimension: product_department {
  type: string
  sql: ${TABLE}.product_department ;;
}

dimension: product_distribution_center_id {
  type: number
  sql: ${TABLE}.product_distribution_center_id ;;
}

dimension: product_id {
  type: number
  # hidden: yes
  sql: ${TABLE}.product_id ;;
}

dimension: product_name {
  type: string
  sql: ${TABLE}.product_name ;;
}

dimension: product_retail_price {
  type: number
  sql: ${TABLE}.product_retail_price ;;
}

dimension: product_sku {
  type: string
  sql: ${TABLE}.product_sku ;;
}

dimension_group: sold {
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
  sql: ${TABLE}.sold_at ;;
}

measure: count {
  type: count
  drill_fields: [id, product_name, products.name, products.id, order_items.count]
}

#Prueba 1:
  parameter: show_product_category_param {
    type: yesno
    label: "Mostrar Product Category"
    default_value: "yes"
  }

  parameter: show_product_brand_param {
    type: yesno
    label: "Mostrar Product Brand"
    default_value: "yes"
  }

  parameter: show_product_sku_param {
    type: yesno
    label: "Mostrar Product SKU"
    default_value: "yes"
  }


dimension: display_product_category {
  type: string
  sql: CASE
       WHEN {% parameter show_product_category_param %} IS TRUE THEN ${product_category}
       ELSE NULL
       END ;;
  label: "Product Category 1"
}

dimension: display_product_brand {
  type: string
  sql: CASE
       WHEN {% parameter show_product_brand_param %} IS TRUE THEN ${product_brand}
       ELSE NULL
       END ;;
  label: "Product Brand 1"
}

dimension: display_product_sku {
  type: string
  sql: CASE
       WHEN {% parameter show_product_sku_param %} IS TRUE THEN ${product_sku}
       ELSE NULL
       END ;;
  label: "Product SKU 1"
}

#Prueba 2:Parámetro para los Reports de Studio
  parameter: Nivel_de_Detalle_Seleccionado {
    type: string
    label: "Nivel_de_Detalle_Seleccionado"

    allowed_value: {
      value: "Category"
      label: "Category"
    }
    allowed_value: {
      value: "Brand"
      label: "Brand"
    }
    allowed_value: {
      value: "SKU"
      label: "SKU"
    }
    default_value: "Category" # Valor por defecto cuando se carga la exploración/dashboard
  }


  # Prueba 3:
  parameter: show_category_column {
    type: yesno
    label: "Product Category 3" # Etiqueta para el botón en el dashboard
    default_value: "yes" # Por defecto, la categoría se muestra
  }

  parameter: show_brand_column {
    type: yesno
    label: "Product Brand 3" # Etiqueta para el botón en el dashboard
    default_value: "yes" # Por defecto, la marca se muestra
  }

  parameter: show_sku_column {
    type: yesno
    label: "Product SKU 3" # Etiqueta para el botón en el dashboard
    default_value: "yes" # Por defecto, el SKU se muestra
  }

  dimension: display_product_category3 {
    type: string
    sql: CASE
       WHEN {% parameter show_category_column %} THEN ${product_category}
       ELSE NULL
       END ;;
    label: "display_product_category3"
  }

#<<<<<<< HEAD
  dimension: display_product_brand3 {
    type: string
    sql: CASE
       WHEN {% parameter show_brand_column %} THEN ${product_brand}
       ELSE NULL
       END ;;
    label: "display_product_brand3"
  }

  dimension: display_product_sku3 {
    type: string
    sql: CASE
       WHEN {% parameter show_sku_column %} THEN ${product_sku}
       ELSE NULL
       END ;;
    label: "display_product_sku3"
  }
#=======
#NUEVO INTENTO DE SELF-SERVICES

  parameter: SelectorN1 {
    group_label: "Selector N1"
    allowed_value: {
      label: "product_category"
      value: "product_category"
    }
    allowed_value: {
      label: "product_department"
      value: "product_department"
    }
    allowed_value: {
      label: "product_brand"
      value: "product_brand"
    }
    allowed_value: {
      label: "product_sku"
      value: "product_sku"
    }
    allowed_value: {
      label: "Ninguna"
      value: "null"
    }

  }
  parameter: SelectorN2 {
    group_label: "Selector N2"
    allowed_value: {
      label: "product_category"
      value: "product_category"
    }
    allowed_value: {
      label: "product_department"
      value: "product_department"
    }
    allowed_value: {
      label: "product_brand"
      value: "product_brand"
    }
    allowed_value: {
      label: "product_sku"
      value: "product_sku"
    }
    allowed_value: {
      label: "Ninguna"
      value: "null"
    }

  }

  parameter: SelectorN3 {
    group_label: "Selector N2"
    allowed_value: {
      label: "product_category"
      value: "product_category"
    }
    allowed_value: {
      label: "product_department"
      value: "product_department"
    }
    allowed_value: {
      label: "product_brand"
      value: "product_brand"
    }
    allowed_value: {
      label: "product_sku"
      value: "product_sku"
    }
    allowed_value: {
      label: "Ninguna"
      value: "null"
    }

  }
  parameter: SelectorN4 {
    group_label: "Selector N2"
    allowed_value: {
      label: "product_category"
      value: "product_category"
    }
    allowed_value: {
      label: "product_department"
      value: "product_department"
    }
    allowed_value: {
      label: "product_brand"
      value: "product_brand"
    }
    allowed_value: {
      label: "product_sku"
      value: "product_sku"
    }
    allowed_value: {
      label: "Ninguna"
      value: "null"
    }

  }

  dimension: dimension_N1 {
    group_label: "Selector N1"
    type: string
    sql: ifnull(case when {%parameter SelectorN1%} = "product_category" then ${product_category}
            when {%parameter SelectorN1%} = "product_department" then ${product_department}
            when {%parameter SelectorN1%} = "product_brand" then ${product_brand}
            when {%parameter SelectorN1%} = "product_sku" then ${product_sku}
            when {% parameter SelectorN1 %} = "Ninguna" then NULL
            else ""
            end, "∅");;
    label_from_parameter: SelectorN1
  }

  dimension: dimension_N2 {
    group_label: "Selector N2"
    type: string
    sql: ifnull(case when {%parameter SelectorN2%} = "product_category" then ${product_category}
            when {%parameter SelectorN2%} = "product_department" then ${product_department}
            when {%parameter SelectorN2%} = "product_brand" then ${product_brand}
            when {%parameter SelectorN2%} = "product_sku" then ${product_sku}
           when {% parameter SelectorN2 %} = "Ninguna" then NULL
            else ""
            end, "∅");;
    label_from_parameter: SelectorN2
  }

  dimension: dimension_N3 {
    group_label: "Selector N3"
    type: string
    sql: ifnull(case when {%parameter SelectorN3%} = "product_category" then ${product_category}
            when {%parameter SelectorN3%} = "product_department" then ${product_department}
            when {%parameter SelectorN3%} = "product_brand" then ${product_brand}
            when {%parameter SelectorN3%} = "product_sku" then ${product_sku}
            when {% parameter SelectorN3 %} = "Ninguna" then NULL
            else ""
            end, "∅");;
    label_from_parameter: SelectorN3
  }

  dimension: dimension_N4 {
    group_label: "Selector N4"
    type: string
    sql: ifnull(case when {%parameter SelectorN4%} = "product_category" then ${product_category}
            when {%parameter SelectorN4%} = "product_department" then ${product_department}
            when {%parameter SelectorN4%} = "product_brand" then ${product_brand}
            when {%parameter SelectorN4%} = "product_sku" then ${product_sku}
            when {% parameter SelectorN4 %} = "Ninguna" then NULL
            else ""
            end, "∅");;
    label_from_parameter: SelectorN4
  }

#>>>>>>> branch 'master' of https://github.com/carlosavendanodevoteam/dev.git

}
