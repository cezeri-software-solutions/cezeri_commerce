################################################################################################################################
"delivery_in_stock":

In Shops OHNE MULTILANGUAGE ist es einfach nur ein String
"delivery_in_stock": "",
In Shops MIT MULTILANGUAGE ist es eine Liste aus "id": STRING und "value": "String"
"delivery_in_stock": [
        {
          "id": "1",
          "value": ""
        },
        {
          "id": "2",
          "value": ""
        },
        {
          "id": "3",
          "value": ""
        }
      ],
Deshalb habe ich ein zusätzliches Feld namens: "delivery_in_stock_multilanguage" eingefüght
"delivery_in_stock_multilanguage": [
            {
              "id": "1",
              "value": ""
            },
            {
              "id": "2",
              "value": ""
            },
            {
              "id": "3",
              "value": ""
            }
          ],
################################################################################################################################
"delivery_out_stock"

Das selbe wie bei "delivery_in_stock"
################################################################################################################################
"meta_description"
"meta_keywords"
"link_rewrite"
"name"
"description"
"description_short"
"available_now"
"available_later"

Das selbe wie bei "delivery_in_stock"
################################################################################################################################
"type": "simple" oder "pack"
"product_type": "" oder "pack"

Bestimmt, ob es ein STANDARDARTIKEL oder ein PRODUCTBÜNDEL ist

Unten unter "associatinos" wird bestimmt aus welchen Artikeln dieser Bündel besteht

"product_bundle": [
                    {
                        "id": "310",
                        "id_product_attribute": "0",
                        "quantity": "1"
                    },
                    {
                        "id": "322",
                        "id_product_attribute": "0",
                        "quantity": "1"
                    },
                    {
                        "id": "326",
                        "id_product_attribute": "0",
                        "quantity": "1"
                    },
                    {
                        "id": "594",
                        "id_product_attribute": "0",
                        "quantity": "1"
                    },
                    {
                        "id": "667",
                        "id_product_attribute": "0",
                        "quantity": "1"
                    },
                    {
                        "id": "712",
                        "id_product_attribute": "0",
                        "quantity": "1"
                    }
                ]
################################################################################################################################
"low_stock_threshold"

In den meisten Fällen null aber kann auch String sein

"low_stock_threshold": null,
"low_stock_threshold": "0",
################################################################################################################################
"active"

String
"0" NICHT aktiv
"1" aktiv
################################################################################################################################
"pack_stock_type"

In den Shops CCF und CCC ist es immer String "0"
In dem Shop MK ist es immer String "3"

Sehr warscheinlich hat es etwas mit variantenartikeln zu tun
################################################################################################################################
"accessories"

Ids der ähnlichen Artikel################################################################################################################################
Nur bei VARIANTEN ARTIKEL:

"combinations"
- sind sub product ids
"product_option_values"
- id der Varianten in Presta unter Varianten
    - z.B. größe 24 hat eine id von 27, dann steht da 27
    - Die Kategorie Id von z.B. größe wird nicht angegeben, da keine id im inneren die gleiche id haben kann. Wenn ich z.B. größen erstelle, die die ids 1,2,3 haben und dann eine Farbe erstelle, bekommt diese automatisch die id 4
"product_features"

"stock_availables"
hat bei Variantenartikeln mehrere Einträge
- "id" = id der stock_availables
- "id_product_attribute" = id der combination, also sub product id
    - Der erste Eintrag ist immer "0", ka warum
################################################################################################################################
Nur bei MULTILANGUAGE ARTIKEL:

"product_bundle"
################################################################################################################################