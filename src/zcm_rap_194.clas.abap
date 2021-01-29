CLASS zcm_rap_194 DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message.

    CONSTANTS:
      BEGIN OF abfall_unknown,
        msgid TYPE symsgid VALUE 'ZRAP_MSG_194',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'ABFALLID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF abfall_unknown .
    CONSTANTS:
      BEGIN OF bestellung_unknown,
        msgid TYPE symsgid VALUE 'ZRAP_MSG_194',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'BESTELLUNGID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF bestellung_unknown .
    CONSTANTS:
      BEGIN OF begin_date_before_system_date,
        msgid TYPE symsgid VALUE 'ZRAP_MSG_194',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'LIEFERDATUM',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF begin_date_before_system_date .
    CONSTANTS:
      BEGIN OF end_date_before_begin_date,
        msgid TYPE symsgid VALUE 'ZRAP_MSG_194',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'LIEFERDATUM',
        attr2 TYPE scx_attrname VALUE 'ABHOLDATUM',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_before_begin_date .
    CONSTANTS:
      BEGIN OF gewicht_groesser_max_gewicht,
        msgid TYPE symsgid VALUE 'ZRAP_MSG_194',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'GEWICHT',
        attr2 TYPE scx_attrname VALUE 'MAXIMALGEWICHT',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gewicht_groesser_max_gewicht .

    METHODS constructor
      IMPORTING
        severity       TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid         LIKE if_t100_message=>t100key OPTIONAL
        previous       TYPE REF TO cx_root OPTIONAL
        abholdatum     TYPE z_bestellung_abd_194 OPTIONAL
        lieferdatum    TYPE z_bestellung_ld_194 OPTIONAL
        gewicht        TYPE z_container_gw_194 OPTIONAL
        maximalgewicht TYPE z_container_gw_194 OPTIONAL
        abfallid       TYPE z_abfall_id_194 OPTIONAL
        bestellungid   TYPE z_bestellung_id_194 OPTIONAL
      .

    DATA abholdatum   TYPE z_bestellung_abd_194 READ-ONLY.
    DATA abfallid     TYPE string READ-ONLY.
    DATA bestellungid TYPE string READ-ONLY.
    DATA lieferdatum  TYPE z_bestellung_ld_194 READ-ONLY.
    DATA gewicht      TYPE z_container_gw_194 READ-ONLY.
    DATA maximalgewicht  TYPE z_container_gw_194 READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_rap_194 IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.

    me->abholdatum = abholdatum.
    me->lieferdatum = lieferdatum.
    me->gewicht = |{ gewicht ALPHA = OUT }|.
    me->maximalgewicht = |{ maximalgewicht ALPHA = OUT }|.
    me->abfallid = |{ abfallid ALPHA = OUT }|.
    me->bestellungid = |{ bestellungid ALPHA = OUT }|.
  ENDMETHOD.
ENDCLASS.
