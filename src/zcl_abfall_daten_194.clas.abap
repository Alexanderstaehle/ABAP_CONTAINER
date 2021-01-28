CLASS zcl_abfall_daten_194 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abfall_daten_194 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: itab         TYPE TABLE OF zabfall_194,
          current_date TYPE timestampl.
    GET TIME STAMP FIELD current_date.


*   fill internal abfall table (itab)
    itab = VALUE #(
      ( a_uuid = '03D5290E594C1EDA93815057FD946624' a_id = '00000001' kategorie = 'M-BAUABFÄLLE' waehrung = 'EUR' preis = '123.00' erstellt_am = '2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( a_uuid = '03D5290E594C1EDA93815057FD946625' a_id = '00000002' kategorie = 'G-BAUABFÄLLE' waehrung = 'EUR' preis = '124.00' erstellt_am = '2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( a_uuid = '03D5290E594C1EDA93815057FD946626' a_id = '00000003' kategorie = 'K-BAUABFÄLLE' waehrung = 'EUR' preis = '125.00' erstellt_am = '2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( a_uuid = '03D5290E594C1EDA93815057FD946627' a_id = '00000004' kategorie = 'BODEN' waehrung = 'EUR' preis = '126.00' erstellt_am = '2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( a_uuid = '03D5290E594C1EDA93815057FD946628' a_id = '00000005' kategorie = 'ERDE' waehrung = 'EUR' preis = '127.00' erstellt_am = '2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( a_uuid = '03D5290E594C1EDA93815057FD946629' a_id = '00000006' kategorie = 'HOLZ' waehrung = 'EUR' preis = '128.00' erstellt_am = '2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( a_uuid = '03D5290E594C1EDA93815057FD946630' a_id = '00000007' kategorie = 'METALL UND SCHROTT' waehrung = 'EUR' preis = '129.00' erstellt_am = '2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')

    ).

*   delete existing entries in the database table
    DELETE FROM zabfall_194.

*   insert the new table entries
    INSERT zabfall_194 FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } abfall daten eingefügt!| ).

  ENDMETHOD.
ENDCLASS.
