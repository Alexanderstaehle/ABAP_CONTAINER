CLASS lhc_Abfall DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Abfall RESULT result.

    METHODS setzeInitialeWaehrung FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Abfall~setzeInitialeWaehrung.

    METHODS berechneAbfallID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Abfall~berechneAbfallID.

ENDCLASS.

CLASS lhc_Abfall IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD setzeInitialeWaehrung.
    READ ENTITIES OF zi_abfall_194 IN LOCAL MODE
        ENTITY Abfall
          FIELDS ( Waehrung ) WITH CORRESPONDING #( keys )
        RESULT DATA(abfaelle).

    DELETE abfaelle WHERE Waehrung IS NOT INITIAL.
    CHECK abfaelle IS NOT INITIAL.

    MODIFY ENTITIES OF zi_abfall_194 IN LOCAL MODE
    ENTITY Abfall
      UPDATE
        FIELDS ( Waehrung )
        WITH VALUE #( FOR abfall IN abfaelle
                      ( %tky         = abfall-%tky
                        Waehrung = 'EUR' ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  """ METHODE WELCHE DIE NÄCHSTE FREIE ID BERECHNET """
  METHOD berechneAbfallID.
    READ ENTITIES OF zi_abfall_194 IN LOCAL MODE
            ENTITY Abfall
              FIELDS ( AbfallID )
              WITH CORRESPONDING #( keys )
            RESULT DATA(abfaelle).

    DELETE abfaelle WHERE AbfallID IS NOT INITIAL.
    CHECK abfaelle IS NOT INITIAL.
    " liest maximale AbfallID
    SELECT SINGLE FROM zabfall_194 FIELDS MAX( a_id ) INTO @DATA(lv_max_abfallid).

    " updatet Abfall mit neuer ID
    MODIFY ENTITIES OF zi_abfall_194 IN LOCAL MODE
      ENTITY Abfall
        UPDATE FIELDS ( AbfallID )
        WITH VALUE #( FOR abfall IN abfaelle INDEX INTO i (
                           %key      = abfall-%key
                           AbfallID  = lv_max_abfallid + i ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

ENDCLASS.
