@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Container Daten - 194'
define root view entity ZI_CONTAINER_194

  as select from zcontainer_194 as Container

  association [1..1] to ZI_ABFALL_194 as _Abfall on $projection.AbfallID = _Abfall.AbfallID
  // association [1..1] to ZI_BESTELLUNG_194     as _Bestellung     on $projection.BestellungID = _Bestellung.BestellungID

{
  key  c_uuid                as ContainerUUID,
       b_id                  as BestellungID,
       a_id                  as AbfallID,
       c_id                  as ContainerID,
       @Semantics.text: true
       _Abfall.Kategorie     as Kategorie,
       @Semantics.text: true
       verfuegbarkeit        as Verfuegbarkeit,
       gewicht               as Gewicht,
       maximalgewicht        as Maximalgewicht,

       /*-- Admin data --*/
       @Semantics.systemDateTime.createdAt: true
       erstellt_am           as Erstellungsdatum,
       @Semantics.systemDateTime.lastChangedAt: true
       aktualisiert_am       as Aktualisierungsdatum,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       local_aktualisiert_am as LokalesAktualisierungsdatum,

       /* Public associations */
       _Abfall
       //_Bestellung
}
