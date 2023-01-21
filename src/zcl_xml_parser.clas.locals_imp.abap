class first_tag_name implementation.

  method value.

    r_value = me->a_value.

  endmethod.
  method constructor.

    me->a_value = i_value.

  endmethod.
  method from_xml.

    constants first_tag type string value '(<.[^(><.)]+>)'.

    r_first_tag_name = new #( |{ conv string( let offset = find( val = i_string_xml
                                                                 regex = first_tag ) + 1
                                                  length = find_end( val = i_string_xml
                                                                     regex = first_tag ) - offset - 1 in
                                              i_string_xml+offset(length) ) case = upper }| ).

  endmethod.

endclass.
class asxml implementation.

  method constructor.

    me->a_value = i_value.

  endmethod.
  method value.

    r_value = me->a_value.

  endmethod.
  method from.

    data(source_tab) = value abap_trans_srcbind_tab( ( name = i_first_tag_name->value( )
                                                       value = new xsdany( i_xml->value( ) ) ) ).

    data(binary_asxml) = value xsdany( ).

    call transformation id source (source_tab)
                           result xml binary_asxml.

    r_asxml = new #( binary_asxml ).

  endmethod.

endclass.
class validated_xml implementation.

  method constructor.

    me->a_value = i_value.

  endmethod.
  method value.

    r_value = me->a_value.

  endmethod.
  method from_original_xml.

    data(xml_reader) = cl_sxml_string_reader=>create( i_xml ).

    data(xml_writer) = cast if_sxml_writer( cl_sxml_string_writer=>create( ) ).

    do.

      data(xml_node) = xml_reader->read_next_node( ).

      if xml_node is not initial.

        try.

          data(open_element_name) = cast if_sxml_open_element( xml_node )->qname.

          data(open_element_no_attributes) = xml_writer->new_open_element( name = |{ open_element_name-name case = upper }|
                                                                           nsuri = open_element_name-namespace ).

          xml_writer->write_node( open_element_no_attributes ).

        catch cx_sy_move_cast_error.

          xml_writer->write_node( xml_node ).

        endtry.

      else.

        exit.

      endif.

    enddo.

    r_validated_xml = new #( cast cl_sxml_string_writer( xml_writer )->get_output( ) ).

  endmethod.

endclass.
