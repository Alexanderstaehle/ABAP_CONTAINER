@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Kunden Daten - 194'
@Search.searchable: true
define root view entity ZI_KUNDE_194

  as select from zkunde_194 as Kunde
  composition [0..*] of ZI_BESTELLUNG_194 as _Bestellung


{
        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.8
  key   k_uuid                as KundeUUID,
        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.8
        k_id                  as KundeID,
        @Semantics.name.givenName: true
        vorname               as Vorname,
        @Search.defaultSearchElement: true
        @Semantics.name.familyName: true
        nachname              as Nachname,
        @Semantics.address.street: true
        addresse_strasse      as Strasse,
        @Semantics.address.number: true
        addresse_nummer       as Hausnummer,
        @Semantics.address.zipCode: true
        addresse_plz          as PLZ,
        @Semantics.address.city: true
        addresse_stadt        as Stadt,
        @Semantics.organization.name: true
        firma                 as Firma,
        @Semantics.text: true
        ansprechpartner       as Ansprechpartner,
        /*-- Admin data --*/
        @Semantics.systemDateTime.createdAt: true
        erstellt_am           as Erstellungsdatum,
        @Semantics.systemDateTime.lastChangedAt: true
        aktualisiert_am       as Aktualisierungsdatum,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        local_aktualisiert_am as LokalesAktualisierungsdatum,
        _Bestellung
}
