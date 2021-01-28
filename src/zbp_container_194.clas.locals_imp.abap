CLASS lhc_Container DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF container_status,
        verfuegbar TYPE c LENGTH 128  VALUE 'Verfügbar',
        belegt     TYPE c LENGTH 128  VALUE 'Belegt',
      END OF container_status.

    METHODS containerStatusFreigeben FOR MODIFY
      IMPORTING keys FOR ACTION Container~containerStatusFreigeben RESULT result.

    METHODS get_instance_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Container RESULT result.

    METHODS berechneContainerID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Container~berechneContainerID.

    METHODS validateAbfall FOR VALIDATE ON SAVE
      IMPORTING keys FOR Container~validateAbfall.

    METHODS setzeInitialenStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Container~setzeInitialenStatus.

    METHODS validateBestellung FOR VALIDATE ON SAVE
      IMPORTING keys FOR Container~validateBestellung.

    METHODS containerStatusBelegen FOR MODIFY
      IMPORTING keys FOR ACTION Container~containerStatusBelegen RESULT result.
    METHODS setzeInitialesMaximalgewicht FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Container~setzeInitialesMaximalgewicht.
    METHODS validateGewicht FOR VALIDATE ON SAVE
      IMPORTING keys FOR Container~validateGewicht.
ENDCLASS.

CLASS lhc_Container IMPLEMENTATION.

  """ METHODE WELCHE DEN AKTUELLEN STATUS FESTLEGT UND IN VARIABLEN SPEICHERT"""
  METHOD get_instance_features.
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
        FIELDS ( Verfuegbarkeit ) WITH CORRESPONDING #( keys )
      RESULT DATA(containers)
      FAILED failed.

    result =
      VALUE #(
        FOR container IN containers
          LET ist_verfuegbar =   COND #( WHEN container-Verfuegbarkeit = container_status-verfuegbar
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled  )
              ist_belegt =   COND #( WHEN container-Verfuegbarkeit = container_status-belegt
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled )
          IN
            ( %tky                 = container-%tky
              %action-containerStatusFreigeben = ist_belegt
              %action-containerStatusBelegen = ist_verfuegbar
             ) ).
  ENDMETHOD.

  """ METHODE WELCHE DIE NÄCHSTE FREIE ID BERECHNET """
  METHOD berechneContainerID.
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
            ENTITY Container
              FIELDS ( ContainerID )
              WITH CORRESPONDING #( keys )
            RESULT DATA(lt_container).

    DELETE lt_container WHERE ContainerID IS NOT INITIAL.
    CHECK lt_container IS NOT INITIAL.
    " liest maximale ContainerID
    SELECT SINGLE FROM zcontainer_194 FIELDS MAX( c_id ) INTO @DATA(lv_max_containerid).

    " updatet Container mit neuer ID
    MODIFY ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
        UPDATE FIELDS ( ContainerID )
        WITH VALUE #( FOR ls_container IN lt_container INDEX INTO i (
                           %key      = ls_container-%key
                           ContainerID  = lv_max_containerid + i ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  """ METHODE WELCHE DEN VERFÜGBARKEITS-STATUS EINES CONTAINERS AUF VERFÜGBAR SETZT UND DIE BESTELLUNGSID LÖSCHT """
  METHOD containerstatusfreigeben.
    " setzt neuen Status und BestellungID auf initial um Verfügbarkeit zu zeigen
    MODIFY ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
         UPDATE
           FIELDS ( BestellungID Verfuegbarkeit Gewicht )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Verfuegbarkeit = container_status-verfuegbar
                             BestellungID = ' '
                             Gewicht = '0' ) )
      FAILED failed
      REPORTED reported.

    " gibt ergebnis der transaktion aus
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(containers).

    result = VALUE #( FOR container IN containers
                        ( %tky   = container-%tky
                          %param = container ) ).
  ENDMETHOD.

  """ METHODE WELCHE VALIDIERT OB ES DIE GEGEBENE ABFALLID GIBT """
  METHOD validateAbfall.
    " lies alle AbfallIDs
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
        FIELDS ( AbfallID ) WITH CORRESPONDING #( keys )
      RESULT DATA(containers).

    DATA abfaelle TYPE SORTED TABLE OF zabfall_194 WITH UNIQUE KEY a_id.

    " Cleaning der Abfall-Daten (löschen aus lokalem Objekt wo AbfallID initial ist)
    abfaelle = CORRESPONDING #( containers DISCARDING DUPLICATES MAPPING a_id = AbfallID EXCEPT * ).
    DELETE abfaelle WHERE a_id IS INITIAL.

    IF abfaelle IS NOT INITIAL.
      " Check ob abfall ID existiert
      SELECT FROM zabfall_194 FIELDS a_id
        FOR ALL ENTRIES IN @abfaelle
        WHERE a_id = @abfaelle-a_id
        INTO TABLE @DATA(abfall_db).
    ENDIF.

    " Fehler Meldung bei nicht vorhandener AbfallID
    LOOP AT containers INTO DATA(container).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky               = container-%tky
                       %state_area        = 'VALIDATE_ABFALL' )
        TO reported-container.

      IF container-AbfallID IS INITIAL OR NOT line_exists( abfall_db[ a_id = container-AbfallID ] ).
        APPEND VALUE #( %tky = container-%tky ) TO failed-container.

        APPEND VALUE #( %tky        = container-%tky
                        %state_area = 'VALIDATE_ABFALL'
                        %msg        = NEW zcm_rap_194(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcm_rap_194=>abfall_unknown
                                          abfallid = container-AbfallID )
                        %element-AbfallID = if_abap_behv=>mk-on )
          TO reported-container.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  """ METHODE WELCHE DEN INITIALEN STATUS EINES CONTAINERS AUF NEUEN STATUS SETZT """
  METHOD setzeInitialenStatus.
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
        FIELDS ( Verfuegbarkeit ) WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    DELETE bestellungen WHERE Verfuegbarkeit IS NOT INITIAL.
    CHECK bestellungen IS NOT INITIAL.

    MODIFY ENTITIES OF zi_container_194 IN LOCAL MODE
    ENTITY Container
      UPDATE
        FIELDS ( Verfuegbarkeit )
        WITH VALUE #( FOR status IN bestellungen
                      ( %tky         = status-%tky
                        Verfuegbarkeit = container_status-verfuegbar ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  """ METHODE WELCHE VALIDIERT OB ES DIE GEGEBENE BESTELLUNGSID GIBT """
  METHOD validateBestellung.
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
        FIELDS ( BestellungID ) WITH CORRESPONDING #( keys )
      RESULT DATA(containers).

    DATA bestellungen TYPE SORTED TABLE OF zbestellung_194 WITH UNIQUE KEY b_id.

    bestellungen = CORRESPONDING #( containers DISCARDING DUPLICATES MAPPING b_id = BestellungID EXCEPT * ).
    DELETE bestellungen WHERE b_id IS INITIAL.

    IF bestellungen IS NOT INITIAL.
      " Check ob bestellung ID in Bestelllungs-Tabelle existiert
      SELECT FROM zbestellung_194 FIELDS b_id
        FOR ALL ENTRIES IN @bestellungen
        WHERE b_id = @bestellungen-b_id
        INTO TABLE @DATA(bestellung_db).
    ENDIF.

    DELETE containers WHERE BestellungID IS INITIAL.
    CHECK containers IS NOT INITIAL.

    " Fehler Meldung bei nicht vorhandener BestellungID
    LOOP AT containers INTO DATA(container).
      " Lösche alle bestehenden Status Nachrichten
      APPEND VALUE #(  %tky               = container-%tky
                       %state_area        = 'VALIDATE_BESTELLUNG' )
        TO reported-container.
      " setze neue Nachricht falls kiene passende BestellungID vorhanden
      IF NOT line_exists( bestellung_db[ b_id = container-BestellungID ] ).
        APPEND VALUE #( %tky = container-%tky ) TO failed-container.

        APPEND VALUE #( %tky        = container-%tky
                        %state_area = 'VALIDATE_BESTELLUNG'
                        %msg        = NEW zcm_rap_194(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcm_rap_194=>bestellung_unknown
                                          bestellungid = container-BestellungID )
                        %element-BestellungID = if_abap_behv=>mk-on )
          TO reported-container.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  """ METHODE WELCHE DEN CONTAINER STATUS AUF BELEGT SETZT """
  METHOD containerStatusBelegen.
    " setzt neuen Status auf belegt zu zeigen
    MODIFY ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
         UPDATE
           FIELDS ( Verfuegbarkeit )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Verfuegbarkeit = container_status-belegt ) )
      FAILED failed
      REPORTED reported.

    " gibt ergebnis der transaktion aus
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
      ENTITY Container
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(containers).

    result = VALUE #( FOR container IN containers
                        ( %tky   = container-%tky
                          %param = container ) ).
  ENDMETHOD.

  METHOD setzeInitialesMaximalgewicht.
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
       ENTITY Container
         FIELDS ( Maximalgewicht ) WITH CORRESPONDING #( keys )
       RESULT DATA(bestellungen).

    DELETE bestellungen WHERE Maximalgewicht IS NOT INITIAL.
    CHECK bestellungen IS NOT INITIAL.

    MODIFY ENTITIES OF zi_container_194 IN LOCAL MODE
    ENTITY Container
      UPDATE
        FIELDS ( Maximalgewicht )
        WITH VALUE #( FOR status IN bestellungen
                      ( %tky         = status-%tky
                        Verfuegbarkeit = '3000' ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateGewicht.
    READ ENTITIES OF zi_container_194 IN LOCAL MODE
        ENTITY Container
          FIELDS ( Gewicht Maximalgewicht ) WITH CORRESPONDING #( keys )
        RESULT DATA(containers).
    DELETE containers WHERE Maximalgewicht IS INITIAL.
    LOOP AT containers INTO DATA(container).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = container-%tky
                       %state_area = 'VALIDATE_WEIGHT' )
        TO reported-container.

      IF container-Gewicht > container-Maximalgewicht.
        APPEND VALUE #( %tky = container-%tky ) TO failed-container.
        APPEND VALUE #( %tky               = container-%tky
                        %state_area        = 'VALIDATE_WEIGHT'
                        %msg               = NEW zcm_rap_194(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_rap_194=>gewicht_groesser_max_gewicht
                                                 gewicht = container-Gewicht
                                                 maximalgewicht   = container-Maximalgewicht )
                        %element-Gewicht = if_abap_behv=>mk-on
                        %element-Maximalgewicht   = if_abap_behv=>mk-on ) TO reported-container.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
