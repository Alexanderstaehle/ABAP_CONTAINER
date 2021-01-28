CLASS zcl_container_daten_194 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_container_daten_194 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: itab         TYPE TABLE OF zcontainer_194.


*   fill internal container table (itab)
    itab = VALUE #(
      ( c_uuid = '02D5290E594C1EDA93815057FD946624' c_id = '00000001' b_id = '00000001' a_id = '00000001' verfuegbarkeit = 'Verfügbar' gewicht = '123' maximalgewicht = '3000'
erstellt_am =
'2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( c_uuid = '02D5290E594C1EDA93815057FD946625' c_id = '00000002' b_id = '00000001' a_id = '00000002' verfuegbarkeit = 'Belegt' gewicht = '' maximalgewicht ='3000' erstellt_am =
'2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( c_uuid = '02D5290E594C1EDA93815057FD946626' c_id = '00000003' b_id = '00000002' a_id = '00000003' verfuegbarkeit = 'Belegt' gewicht = '' maximalgewicht ='3000' erstellt_am =
'2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( c_uuid = '02D5290E594C1EDA93815057FD946627' c_id = '00000004' b_id = '00000002' a_id = '00000004' verfuegbarkeit = 'Verfügbar' gewicht = '125' maximalgewicht ='3000'
erstellt_am =
'2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( c_uuid = '02D5290E594C1EDA93815057FD946628' c_id = '00000005' b_id = '00000003' a_id = '00000005' verfuegbarkeit = 'Belegt' gewicht = '' maximalgewicht ='3000' erstellt_am =
'2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( c_uuid = '02D5290E594C1EDA93815057FD946629' c_id = '00000006' b_id = '00000004' a_id = '' verfuegbarkeit = 'Belegt' gewicht = '126' maximalgewicht ='3000' erstellt_am = '2021011004355.8765432' aktualisiert_am =
'2021011004355.8765432')
      ( c_uuid = '02D5290E594C1EDA93815057FD946630' c_id = '00000007' b_id = '00000005' a_id = '' verfuegbarkeit = 'Verfügbar' gewicht = '' maximalgewicht ='3000' erstellt_am = '2021011004355.8765432' aktualisiert_am =
'2021011004355.8765432')

    ).

*   delete existing entries in the database table
    DELETE FROM zcontainer_194.

*   insert the new table entries
    INSERT zcontainer_194 FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } container daten eingefügt!| ).

  ENDMETHOD.
ENDCLASS.
