@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection view für Bestellung'
@ObjectModel.resultSet.sizeCategory: #XS

@ObjectModel.semanticKey: ['BestellungID']

@UI: {
 headerInfo: { typeName: 'Bestellung', typeNamePlural: 'Bestellungen', title: { type: #STANDARD, value: 'BestellungID' } } }
define view entity ZC_BESTELLUNG_194
  as projection on ZI_BESTELLUNG_194 as Bestellung
{
  key BestellungUUID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_KUNDE_194', element: 'KundeUUID'} }]
      KundeUUID,
      BestellungID,
      Lieferadresse,
      @Search.defaultSearchElement: true
      Lieferdatum,
      @Search.defaultSearchElement: true
      Abholdatum,
      Details,
      Status,
      Erstellungsdatum,
      Aktualisierungsdatum,
      LokalesAktualisierungsdatum,
      /* Associations */
      _Kunde : redirected to parent ZC_KUNDE_194

}
