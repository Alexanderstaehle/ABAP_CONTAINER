CLASS zcl_kunden_daten_194 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_kunden_daten_194 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF zkunde_194.

*   fill internal kunden table (itab)
    itab = VALUE #(
      ( k_uuid = '04D5290E594C1EDA93815057FD946624' k_id = '00000022' vorname = 'Peter' nachname = 'Dilling' addresse_strasse = 'Musterstraße' addresse_nummer = '14' addresse_plz = '12345' addresse_stadt = 'Musterstadt' firma = 'Musterfirma'
ansprechpartner = 'Max Mustermann' erstellt_am =
'2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( k_uuid = '04D5290E594C1EDA93815057FD946625' k_id = '00000023' vorname = 'Heinz' nachname = 'Schmatz' addresse_strasse = 'Musterstraße' addresse_nummer = '12' addresse_plz = '12345' addresse_stadt = 'Musterstadt' firma = '' ansprechpartner = ''
erstellt_am = '2021011004355.8765432' aktualisiert_am =
'2021011004355.8765432')
      ( k_uuid = '04D5290E594C1EDA93815057FD946626' k_id = '00000024' vorname = 'Thomas' nachname = 'Müller' addresse_strasse = 'Musterstraße' addresse_nummer = '10' addresse_plz = '12345' addresse_stadt = 'Musterstadt' firma = 'Musterfirma2'
ansprechpartner = 'Max Musterfrau' erstellt_am =
'2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( k_uuid = '04D5290E594C1EDA93815057FD946627' k_id = '00000025' vorname = 'Rüdiger' nachname = 'Seger' addresse_strasse = 'Musterstraße' addresse_nummer = '9' addresse_plz = '12345' addresse_stadt = 'Musterstadt' firma = '' ansprechpartner = ''
erstellt_am = '2021011004355.8765432' aktualisiert_am =
'2021011004355.8765432')
      ( k_uuid = '04D5290E594C1EDA93815057FD946628' k_id = '00000026' vorname = 'Petra' nachname = 'Reiner' addresse_strasse = 'Musterstraße' addresse_nummer = '16' addresse_plz = '12345' addresse_stadt = 'Musterstadt' firma = 'Musterfirma3'
ansprechpartner = 'Gerlinde Mustermann' erstellt_am =
'2021011004355.8765432' aktualisiert_am = '2021011004355.8765432')
      ( k_uuid = '04D5290E594C1EDA93815057FD946629' k_id = '00000027' vorname = 'Claudia' nachname = 'Hofmann' addresse_strasse = 'Musterstraße' addresse_nummer = '19' addresse_plz = '12345' addresse_stadt = 'Musterstadt' firma = '' ansprechpartner = ''
erstellt_am = '2021011004355.8765432' aktualisiert_am =
'2021011004355.8765432')

    ).

*   delete existing entries in the database table
    DELETE FROM zkunde_194.

*   insert the new table entries
    INSERT zkunde_194 FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } kunden daten eingefügt!| ).

  ENDMETHOD.
ENDCLASS.
