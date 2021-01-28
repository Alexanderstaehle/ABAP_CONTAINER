CLASS lhc_Kunde DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS berechneKundeID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Kunde~berechneKundeID.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Kunde RESULT result.

ENDCLASS.

CLASS lhc_Kunde IMPLEMENTATION.

  METHOD berechneKundeID.
    " lese alle KundenIDs
    READ ENTITIES OF zi_kunde_194 IN LOCAL MODE
            ENTITY Kunde
              FIELDS ( KundeID )
              WITH CORRESPONDING #( keys )
            RESULT DATA(lt_kunde).
    " lösche alle Kunden aus lokalem Objekt welche bereits eine ID haben
    DELETE lt_kunde WHERE KundeID IS NOT INITIAL.
    " check ob überhaupt eine neue Kunden ID benötigt wird
    CHECK lt_kunde IS NOT INITIAL.
    " lies höchste KundenID
    SELECT SINGLE FROM zkunde_194 FIELDS MAX( k_id ) INTO @DATA(lv_max_kundeid).
    " update neuen Eintrag mit neuer KundenID
    MODIFY ENTITIES OF zi_kunde_194 IN LOCAL MODE
      ENTITY Kunde
        UPDATE FIELDS ( KundeID )
        WITH VALUE #( FOR ls_kunde IN lt_kunde INDEX INTO i (
                           %key      = ls_kunde-%key
                           KundeID  = lv_max_kundeid + i ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.


  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.
