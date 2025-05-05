view: dojos_aikido {
  sql_table_name: `carlos-avendano-sandbox.sports_movements_dataset.dojos_aikido` ;;

  dimension: c_p_ {
    type: string
    label: "Códigos Postales"
    sql: ${TABLE}.C_P_ ;;
    map_layer_name:  postal
  }
  dimension: ccaa {
    type: string
    sql: ${TABLE}.CCAA ;;
    map_layer_name:  comunidades
  }
  dimension: ccaa_nombre {
    type: string
    sql: ${TABLE}.CCAA_nombre ;;
  }
  dimension: cod_provincia {
    type: string
    sql: ${TABLE}.Cod_provincia ;;
    map_layer_name: provinces
  }
  dimension: direcci__n {
    label: "Dirección"
    type: string
    sql: ${TABLE}.Direcci__n ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.Email ;;
  }
  dimension: grado {
    type: string
    sql:
    REGEXP_REPLACE(
      REPLACE(
        REGEXP_REPLACE(
          REGEXP_REPLACE(
            TRIM(LOWER(${TABLE}.Grado)),
            r'°', 'º'
          ),
          r'\.+$', ''
        ),
        ' ', ''
      ),
      r'(ºdan)y\d+ºdan', 'ºdan'
    ) ;;
  }


  dimension: inf_ {
    type: string
    sql: ${TABLE}.Inf_ ;;
  }
  dimension: localidad {
    type: string
    sql: ${TABLE}.Localidad ;;
  }
  dimension: nombre {
    type: string
    sql: ${TABLE}.Nombre ;;
  }
  dimension: organizaci__n {
    label: "Organización"
    type: string
    sql: ${TABLE}.Organizaci__n ;;
  }
  dimension: profesor {
    type: string
    sql: ${TABLE}.Profesor ;;
  }
  dimension: provincia_nombre {
    type: string
    sql: ${TABLE}.provincia_nombre ;;
  }
  dimension: tel__fono {
    label: "Teléfono"
    type: number
    sql: ${TABLE}.Tel__fono ;;
  }
  dimension: web {
    type: string
    sql: ${TABLE}.Web ;;
  }
  measure: count {
    type: count
  }
}
