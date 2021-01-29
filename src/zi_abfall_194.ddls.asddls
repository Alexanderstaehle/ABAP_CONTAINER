@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Abfall Daten - 194'
@Search.searchable: true
define root view entity ZI_ABFALL_194

  as select from zabfall_194 as Abfall

  association [0..*] to ZI_CONTAINER_194 as _Container on $projection.AbfallID = _Container.AbfallID


{
  key  a_uuid                as AbfallUUID,
       @Search.defaultSearchElement: true
       @Search.fuzzinessThreshold: 0.8
       a_id                  as AbfallID,
       @Search.defaultSearchElement: true
       @Search.fuzzinessThreshold: 0.8
       kategorie             as Kategorie,
       waehrung              as Waehrung,
       @Semantics.amount.currencyCode: 'Waehrung'
       preis                 as Preis,

       /*-- Admin data --*/
       @Semantics.systemDateTime.createdAt: true
       erstellt_am           as Erstellungsdatum,
       @Semantics.systemDateTime.lastChangedAt: true
       aktualisiert_am       as Aktualisierungsdatum,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       local_aktualisiert_am as LokalesAktualisierungsdatum,
       _Container
}
