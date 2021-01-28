@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.resultSet.sizeCategory: #XS

@UI: {
 headerInfo: { typeName: 'Kunde', typeNamePlural: 'Kunden', title: { type: #STANDARD, value: 'KundeID' } } }

@Search.searchable: true
@EndUserText.label: 'Projection view für Kunde'
@ObjectModel.semanticKey: ['KundeID']

define root view entity ZC_KUNDE_194
  as projection on ZI_KUNDE_194 as Kunde
{

  key KundeUUID,
      KundeID,
      Vorname,
      Nachname,
      Strasse,
      Hausnummer,
      PLZ,
      Stadt,
      Firma,
      Ansprechpartner,
      Erstellungsdatum,
      Aktualisierungsdatum,
      LokalesAktualisierungsdatum,
      _Bestellung  : redirected to composition child ZC_BESTELLUNG_194

}
