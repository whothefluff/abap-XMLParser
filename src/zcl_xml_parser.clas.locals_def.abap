"! Parsed XML data
class validated_xml definition "#EC CLAS_FINAL
                    create public.

  public section.

    types t_value type xsdany.

    methods constructor
              importing
                i_value type validated_xml=>t_value.

    methods value
              returning
                value(r_value) type validated_xml=>t_value.

    "! <p class="shorttext synchronized" lang="EN"></p>
    "!
    "! @parameter i_xml | <p class="shorttext synchronized" lang="EN">XML data as is</p>
    "! @parameter r_validated_xml | <p class="shorttext synchronized" lang="EN">XML data after parsing using sXML library</p>
    "! @raising cx_sxml_error | <p class="shorttext synchronized" lang="EN">Reader/writer error during parsing using sXML library</p>
    class-methods from_original_xml
                    importing
                      i_xml type xsdany
                    returning
                      value(r_validated_xml) type ref to validated_xml
                    raising
                      cx_sxml_error.

  protected section.

    data a_value type validated_xml=>t_value.

endclass.
"! Name of the first tag in an XML file
class first_tag_name definition "#EC CLAS_FINAL
                     create public.

  public section.

    types t_value type string.

    methods constructor
              importing
                i_value type first_tag_name=>t_value.

    methods value
              returning
                value(r_value) type first_tag_name=>t_value.

    "! <p class="shorttext synchronized" lang="EN"></p>
    "!
    "! @parameter i_string_xml | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter r_first_tag_name | <p class="shorttext synchronized" lang="EN">First name found</p>
    "! @raising cx_sy_matcher | <p class="shorttext synchronized" lang="EN">Regular expression error</p>
    "! @raising cx_sy_data_access_error | <p class="shorttext synchronized" lang="EN"></p>
    class-methods from_xml
                    importing
                      i_string_xml type string
                    returning
                      value(r_first_tag_name) type ref to first_tag_name
                    raising
                      cx_sy_matcher
                      cx_sy_data_access_error.

  protected section.

    data a_value type first_tag_name=>t_value.

endclass.
"! Canonical XML Representation
class asxml definition "#EC CLAS_FINAL
            create public.

  public section.

    types t_value type xsdany.

    methods constructor
              importing
                i_value type asxml=>t_value.

    methods value
              returning
                value(r_value) type asxml=>t_value.

    "! <p class="shorttext synchronized" lang="EN"></p>
    "!
    "! @parameter i_xml | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter i_first_tag_name | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter r_asxml | <p class="shorttext synchronized" lang="EN">XML data in asXML format</p>
    "! @raising cx_transformation_error | <p class="shorttext synchronized" lang="EN">CALL TRANSFORMATION error</p>
    "! @raising cx_sy_matcher | <p class="shorttext synchronized" lang="EN">Regular expression error</p>
    "! @raising cx_sy_data_access_error | <p class="shorttext synchronized" lang="EN"></p>
    class-methods from
                    importing
                      i_xml type ref to validated_xml
                      i_first_tag_name type ref to first_tag_name
                    returning
                      value(r_asxml) type ref to asxml
                    raising
                      cx_transformation_error
                      cx_sy_matcher
                      cx_sy_data_access_error.

  protected section.

    data a_value type asxml=>t_value.

endclass.
