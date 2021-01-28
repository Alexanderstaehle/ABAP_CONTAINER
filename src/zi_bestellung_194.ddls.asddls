@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bestellung Daten - 194'
@Search.searchable: true
define view entity ZI_BESTELLUNG_194

  as select from zbestellung_194 as Bestellung

  /* Associations */
  association to parent ZI_KUNDE_194 as _Kunde on $projection.KundeUUID = _Kunde.KundeUUID
{
  key  b_uuid                                                                                                                      as BestellungUUID,
       @Search.defaultSearchElement: true
       @Search.fuzzinessThreshold: 0.8
       b_id                                                                                                                        as BestellungID,
       k_uuid                                                                                                                      as KundeUUID,
       concat_with_space(concat_with_space(_Kunde.Strasse, _Kunde.Hausnummer, 1), concat_with_space(_Kunde.PLZ, _Kunde.Stadt,1),2) as Lieferadresse,
       @Semantics.businessDate.from: true
       lieferdatum                                                                                                                 as Lieferdatum,
       @Semantics.businessDate.to: true
       abholdatum                                                                                                                  as Abholdatum,
       @Semantics.text: true
       details                                                                                                                     as Details,
       @Semantics.text: true
       status                                                                                                                      as Status,

       /*-- Admin data --*/
       @Semantics.systemDateTime.createdAt: true
       erstellt_am                                                                                                                 as Erstellungsdatum,
       @Semantics.systemDateTime.lastChangedAt: true
       aktualisiert_am                                                                                                             as Aktualisierungsdatum,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       local_aktualisiert_am                                                                                                       as LokalesAktualisierungsdatum,

       /* Public associations */
       _Kunde
}
