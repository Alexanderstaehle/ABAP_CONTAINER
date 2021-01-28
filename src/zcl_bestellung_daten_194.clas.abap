CLASS zcl_bestellung_daten_194 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bestellung_daten_194 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: itab         TYPE TABLE OF zbestellung_194,
          current_date TYPE timestampl.
    GET TIME STAMP FIELD current_date.


*   fill internal bestellung table (itab)
    itab = VALUE #(
      ( b_uuid = '01D5290E594C1EDA93815057FD946624' b_id = '00000001' k_uuid = '04D5290E594C1EDA93815057FD946624' lieferdatum = '20210129' abholdatum = '20210214' details = 'Vor Hintereingang platzieren' status = 'Eingegangen' erstellt_am =
'2021011004355.8765432'
aktualisiert_am =
'2021011004355.8765432')
      ( b_uuid = '01D5290E594C1EDA93815057FD946625' b_id = '00000002' k_uuid = '04D5290E594C1EDA93815057FD946624' lieferdatum = '20210129' abholdatum = '20210212' details = 'Hinter Hintereingang platzieren' status = 'Bearbeitung' erstellt_am =
'2021011004355.8765432'
aktualisiert_am
=
'2021011004355.8765432')
      ( b_uuid = '01D5290E594C1EDA93815057FD946626' b_id = '00000003' k_uuid = '04D5290E594C1EDA93815057FD946625' lieferdatum = '20210129' abholdatum = '20210210' details = 'Vor Hintereingang platzieren' status = 'Eingegangen' erstellt_am =
'2021011004355.8765432'
aktualisiert_am =
'2021011004355.8765432')
      ( b_uuid = '01D5290E594C1EDA93815057FD946627' b_id = '00000004' k_uuid = '04D5290E594C1EDA93815057FD946625' lieferdatum = '20210129' abholdatum = '20210211' details = 'Neben Hintereingang platzieren' status = 'Abgeschlossen' erstellt_am =
'2021011004355.8765432'
aktualisiert_am
=
'2021011004355.8765432')
      ( b_uuid = '01D5290E594C1EDA93815057FD946628' b_id = '00000005' k_uuid = '04D5290E594C1EDA93815057FD946626' lieferdatum = '20210129' abholdatum = '20210209' details = 'Gegenüber Hintereingang platzieren' status = 'Eingegangen' erstellt_am =
'2021011004355.8765432'
aktualisiert_am =
'2021011004355.8765432')
      ( b_uuid = '01D5290E594C1EDA93815057FD946629' b_id = '00000006' k_uuid = '04D5290E594C1EDA93815057FD946627' lieferdatum = '20210129' abholdatum = '20210215' details = 'Vor Hintereingang platzieren' status = 'Bearbeitung' erstellt_am =
'2021011004355.8765432'
aktualisiert_am =
'2021011004355.8765432')
      ( b_uuid = '01D5290E594C1EDA93815057FD946630' b_id = '00000007' k_uuid = '04D5290E594C1EDA93815057FD946628' lieferdatum = '20210129' abholdatum = '20210217' details = 'Vor Hintereingang platzieren' status = 'Abgeschlossen' erstellt_am =
'2021011004355.8765432'
aktualisiert_am
=
'2021011004355.8765432')

    ).

*   delete existing entries in the database table
    DELETE FROM zbestellung_194.

*   insert the new table entries
    INSERT zbestellung_194 FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } bestellung daten eingefügt!| ).

  ENDMETHOD.
ENDCLASS.
