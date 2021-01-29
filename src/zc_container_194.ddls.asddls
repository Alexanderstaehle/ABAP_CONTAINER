@EndUserText.label: 'Container'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.resultSet.sizeCategory: #XS

@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['ContainerID']

@UI: {
 headerInfo: { typeName: 'Container', typeNamePlural: 'Container', title: { type: #STANDARD, value: 'ContainerID' } } }

@Search.searchable: true

define root view entity ZC_CONTAINER_194
  as projection on ZI_CONTAINER_194 as Container
{
  key ContainerUUID,
      // @Consumption.valueHelpDefinition: [{ entity : {name: 'ZC_BESTELLUNG_194', element: 'BestellungID'  } }]
      @EndUserText.label: 'Bestellung auswählen'
      @Search.defaultSearchElement: true
      BestellungID,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZC_ABFALL_194', element: 'AbfallID'  } }]
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Abfall auswählen'
      AbfallID,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZC_ABFALL_194', element: 'Kategorie' }}]
      @ObjectModel.foreignKey.association: '_Abfall'
      Kategorie,
      @Search.defaultSearchElement: true
      ContainerID,
      Verfuegbarkeit,
      Gewicht,
      Maximalgewicht,
      Erstellungsdatum,
      Aktualisierungsdatum,
      LokalesAktualisierungsdatum,
      /* Associations */
      _Abfall
}
