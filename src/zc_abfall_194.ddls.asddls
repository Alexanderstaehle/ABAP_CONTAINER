@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection view für Abfall'
@ObjectModel.resultSet.sizeCategory: #XS

@ObjectModel.semanticKey: ['AbfallID']

@UI: {
 headerInfo: { typeName: 'Abfall', typeNamePlural: 'Abfälle', title: { type: #STANDARD, value: 'AbfallID' } } }
define root view entity ZC_ABFALL_194
  as projection on ZI_ABFALL_194 as Abfall
{
  key AbfallUUID,
      AbfallID,
      Kategorie,
      Waehrung,
      Preis,
      Erstellungsdatum,
      Aktualisierungsdatum,
      LokalesAktualisierungsdatum

}
