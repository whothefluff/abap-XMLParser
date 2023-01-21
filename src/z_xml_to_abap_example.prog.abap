report z_xml_to_abap_example.

constants: information_message type c length 1 value 'I',
           error_message like information_message value 'E'.

start-of-selection.

  "SIMPLE XML
  types: begin of book,
           name type string,
           "author TYPE string,"if this element is not found in the ABAP type the conversion ignores it and proceeds with the rest
           language type xsdlanguage,
           genre type string,
         end of book.

  data(simple_xml_string) = |<?xml version="1.0" encoding="UTF-8"?><book><name>A Song of Ice and Fire</name><author>George R. R. Martin</author><language>EN</language><genre>Epic fantasy</genre></book>|.

  try.

    field-symbols <book> type book.

    data(book_type) = cast cl_abap_datadescr( cl_abap_typedescr=>describe_by_data( value book( ) ) ).

    data(book_xml) = new zcl_xml_parser( simple_xml_string ).

    data(book) = book_xml->convert_to_abap( book_type ).

    assign book->* to <book>.

    break-point. "#EC NOBREAK open debug to check result

  catch zcx_xml_parser into data(simple_xml_data_to_abap_error).

    if simple_xml_data_to_abap_error->previous is bound.

      message simple_xml_data_to_abap_error->previous type information_message display like information_message.

  "PREVIOUS exceptions indicate the kind of error there was during the conversion:

  " cx_parameter_invalid_range
  " cx_sy_codepage_converter_init
  " cx_sy_conversion_codepage
  " cx_parameter_invalid_type
     "it shouldn't happen, but it means cl_abap_codepage=>convert_to failed

  " cx_sy_move_cast_error
     "using OREFs as elements is not entirely allowed

  " cx_sxml_error
     "some error within the reader/writer processes

  " cx_transformation_error
     "usually occurs in the final step of the conversion process: ABAP type and XML data are not compatible (changing the ABAP type needed)

    else.

      message simple_xml_data_to_abap_error type information_message display like error_message.
      "no PREVIOUS exception means ABAP type and XML are totally incompatible and the process did the conversion as it could (it failed because it did not find matches)

    endif.

  endtry.

  "LESS SIMPLE XML
  types: color_swatch_line type string,
         begin of catalog_item_line,
           item_number type string,
           price type decfloat34,
           size type standard table of color_swatch_line with empty key,
         end of catalog_item_line,
         catalog_item type standard table of catalog_item_line with empty key,
         product type catalog_item,
         begin of catalog,
           product type product,
         end of catalog.

  data(complex_xml_string) = |<?xml version="1.0"?>| &&
                             |<?xml-stylesheet href="catalog.xsl" type="text/xsl"?>| &&
                             "|<!DOCTYPE catalog SYSTEM "catalog.dtd">| && "no DTDs allowed
                             |<catalog>| &&
                                |<product description="Cardigan Sweater" product_image="cardigan.jpg">| &&
                                   |<catalog_item gender="Men's">| &&
                                      |<item_number>QWZ5671</item_number>| &&
                                      |<price>39.95</price>| &&
                                      |<size description="Medium">| &&
                                         |<color_swatch image="red_cardigan.jpg">Red</color_swatch>| &&
                                         |<color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>| &&
                                      |</size>| &&
                                      |<size description="Large">| &&
                                         |<color_swatch image="red_cardigan.jpg">Red</color_swatch>| &&
                                         |<color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>| &&
                                      |</size>| &&
                                   |</catalog_item>| &&
                                   |<catalog_item gender="Women's">| &&
                                      |<item_number>RRX9856</item_number>| &&
                                      |<price>42.50</price>| &&
                                      |<size description="Small">| &&
                                         |<color_swatch image="red_cardigan.jpg">Red</color_swatch>| &&
                                         |<color_swatch image="navy_cardigan.jpg">Navy</color_swatch>| &&
                                         |<color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>| &&
                                      |</size>| &&
                                      |<size description="Medium">| &&
                                         |<color_swatch image="red_cardigan.jpg">Red</color_swatch>| &&
                                         |<color_swatch image="navy_cardigan.jpg">Navy</color_swatch>| &&
                                         |<color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>| &&
                                         |<color_swatch image="black_cardigan.jpg">Black</color_swatch>| &&
                                      |</size>| &&
                                      |<size description="Large">| &&
                                         |<color_swatch image="navy_cardigan.jpg">Navy</color_swatch>| &&
                                         |<color_swatch image="black_cardigan.jpg">Black</color_swatch>| &&
                                      |</size>| &&
                                      |<size description="Extra Large">| &&
                                         |<color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>| &&
                                         |<color_swatch image="black_cardigan.jpg">Black</color_swatch>| &&
                                      |</size>| &&
                                   |</catalog_item>| &&
                                |</product>| &&
                             |</catalog>|.

  "xml
  "  product
  "    catalog_item (several elements)
  "      item_number
  "      price
  "      size
  "        color (several elements)

  "var
  "  product (ITAB)
  "    item_number
  "    price
  "    size (ITAB)
  "      table_line

  try.

    data(catalog_type) = cast cl_abap_datadescr( cl_abap_typedescr=>describe_by_data( value catalog( ) ) ).

    data(catalog) = new zcl_xml_parser( complex_xml_string )->convert_to_abap( catalog_type ).

    assign catalog->* to field-symbol(<catalog>) casting type handle catalog_type.

    break-point. "#EC NOBREAK open debug to check result

  catch zcx_xml_parser into data(conversion_error).
    "appropriate error handling when used in real code (looking at you, regular ABAP developer)
    message conversion_error type information_message display like error_message.

  endtry.
