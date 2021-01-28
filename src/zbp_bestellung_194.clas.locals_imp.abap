CLASS lhc_bestellung DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF bestell_status,
        eingegangen   TYPE c LENGTH 128  VALUE 'Eingegangen',
        bearbeitung   TYPE c LENGTH 128  VALUE 'Bearbeitung',
        abgeschlossen TYPE c LENGTH 128  VALUE 'Abgeschlossen',
      END OF bestell_status.

    METHODS bestellStatusStarten FOR MODIFY
      IMPORTING keys FOR ACTION Bestellung~bestellStatusStarten RESULT result.

    METHODS bestellStatusAbschluss FOR MODIFY
      IMPORTING keys FOR ACTION Bestellung~bestellStatusAbschluss RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Bestellung RESULT result.

    METHODS berechneBestellungID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Bestellung~berechneBestellungID.

    METHODS setzeInitialenStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Bestellung~setzeInitialenStatus.
    METHODS validateDaten FOR VALIDATE ON SAVE
      IMPORTING keys FOR Bestellung~validateDaten.



ENDCLASS.

CLASS lhc_bestellung IMPLEMENTATION.

  METHOD bestellStatusAbschluss.

    MODIFY ENTITIES OF zi_kunde_194 IN LOCAL MODE
    " Status Feld updaten
      ENTITY Bestellung
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = bestell_status-abgeschlossen ) )
      FAILED failed
      REPORTED reported.

    " Response tabelle füllen
    READ ENTITIES OF zi_kunde_194 IN LOCAL MODE
      ENTITY Bestellung
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    result = VALUE #( FOR bestellung IN bestellungen
                        ( %tky   = bestellung-%tky
                          %param = bestellung ) ).
  ENDMETHOD.

  METHOD bestellStatusStarten.
    " Status Feld updaten
    MODIFY ENTITIES OF zi_kunde_194 IN LOCAL MODE
      ENTITY Bestellung
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = bestell_status-bearbeitung ) )
      FAILED failed
      REPORTED reported.

    " Response tabelle füllen
    READ ENTITIES OF zi_kunde_194 IN LOCAL MODE
      ENTITY Bestellung
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    result = VALUE #( FOR bestellung IN bestellungen
                        ( %tky   = bestellung-%tky
                          %param = bestellung ) ).
  ENDMETHOD.

  METHOD get_features.
    READ ENTITIES OF zi_kunde_194 IN LOCAL MODE
      ENTITY Bestellung
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen)
      FAILED failed.
    " füllt response tabelle mit den aktuellen status werten und setzt globale variablen
    result =
      VALUE #(
        FOR bestellung IN bestellungen
          LET ist_bearbeitung =   COND #( WHEN bestellung-Status = bestell_status-bearbeitung
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled  )
              ist_eingegangen =   COND #( WHEN bestellung-Status = bestell_status-eingegangen
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled )
          IN
            ( %tky                 = bestellung-%tky
              %action-bestellStatusStarten = ist_eingegangen
              %action-bestellStatusAbschluss = ist_bearbeitung
             ) ).
  ENDMETHOD.

  METHOD berechneBestellungID.
    DATA max_bestellungid TYPE z_bestellung_id_194.
    DATA update TYPE TABLE FOR UPDATE zi_kunde_194\\Bestellung.


    READ ENTITIES OF zi_kunde_194 IN LOCAL MODE
    ENTITY Bestellung BY \_Kunde
      FIELDS ( KundeUUID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(kunden).
    " liest alle BestellungsIDs die es gibt
    LOOP AT kunden INTO DATA(kunde).
      READ ENTITIES OF zi_kunde_194 IN LOCAL MODE
        ENTITY Kunde BY \_Bestellung
          FIELDS ( BestellungID )
        WITH VALUE #( ( %tky = kunde-%tky ) )
        RESULT DATA(bestellungen).
      " sucht höchste ID in allen Bestellungen
      max_bestellungid ='0000'.
      LOOP AT bestellungen INTO DATA(bestellung).
        IF bestellung-BestellungID > max_bestellungid.
          max_bestellungid = bestellung-BestellungID.
        ENDIF.
      ENDLOOP.
      " setzt neue MaxID +1 als BestellungID in lokalen Daten
      LOOP AT bestellungen INTO bestellung WHERE BestellungID IS INITIAL.
        max_bestellungid += 1.
        APPEND VALUE #( %tky      = bestellung-%tky
                        BestellungID = max_bestellungid
                      ) TO update.
      ENDLOOP.
    ENDLOOP.
    " updated persistente Tabelle mit lokalen update-Daten
    MODIFY ENTITIES OF zi_kunde_194 IN LOCAL MODE
    ENTITY Bestellung
      UPDATE FIELDS ( BestellungID ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD setzeInitialenStatus.
    " liest alle Bestellung
    READ ENTITIES OF zi_kunde_194 IN LOCAL MODE
      ENTITY Bestellung
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(stati).
    " löscht alle Bestellungen aus lokalem Objekt in denen der Bestell-Status schon gesetzt ist
    DELETE stati WHERE Status IS NOT INITIAL.
    CHECK stati IS NOT INITIAL.
    " setzt initialen Status für alle Bestellungen, welche neu waren
    MODIFY ENTITIES OF zi_kunde_194 IN LOCAL MODE
    ENTITY Bestellung
      UPDATE
        FIELDS ( Status )
        WITH VALUE #( FOR status IN stati
                      ( %tky         = status-%tky
                        Status = bestell_status-eingegangen ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.


  METHOD validateDaten.
    READ ENTITIES OF zi_kunde_194 IN LOCAL MODE
        ENTITY Bestellung
          FIELDS ( Lieferdatum Abholdatum ) WITH CORRESPONDING #( keys )
        RESULT DATA(bestellungen).

    LOOP AT bestellungen INTO DATA(bestellung).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = bestellung-%tky
                       %state_area = 'VALIDATE_DATES' )
        TO reported-bestellung.

      IF bestellung-Abholdatum < bestellung-Lieferdatum.
        APPEND VALUE #( %tky = bestellung-%tky ) TO failed-bestellung.
        APPEND VALUE #( %tky               = bestellung-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcm_rap_194(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_rap_194=>end_date_before_begin_date
                                                 abholdatum = bestellung-Abholdatum
                                                 lieferdatum   = bestellung-Lieferdatum )
                        %element-Abholdatum = if_abap_behv=>mk-on
                        %element-Lieferdatum   = if_abap_behv=>mk-on ) TO reported-bestellung.

      ELSEIF bestellung-Lieferdatum < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = bestellung-%tky ) TO failed-bestellung.
        APPEND VALUE #( %tky               = bestellung-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcm_rap_194(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_rap_194=>begin_date_before_system_date
                                                 lieferdatum = bestellung-Lieferdatum )
                        %element-Lieferdatum = if_abap_behv=>mk-on ) TO reported-bestellung.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
