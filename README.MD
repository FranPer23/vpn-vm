# Scopo

L'obiettivo del progetto è **creare due Virtual Network in Peering con una VPN nella prima**. </br>
Si distribuiscono anche due Windows Server per effettuare le prove. </br>
I server sono dotati di un IP pubblico ed hanno le porte RDP abilitate.</br>
Dopo la distribuzione bisgna scaricare il software disponibile nel portale per la connessione VPN punto-sito.</br>
Testare la connessione RDP prima tramite gli IP privati via VPN e poi con gli IP pubblici.
La password delle VM si trova nel secret della keyvault.

## Attenzione

Per eseguire l'esercizio bisogna avere un certificato a disposizione, se non c'è crearlo con lo script PS.

## Elenco file

| File | Descrizione |
|-------------------|----------------------------------------|
| main.tf | Dichiara solo il provider e crea il gruppo di risorse |
| variables.tf | Varibili per main.tf |
| Varnetworkbase.tf| Definisce le variabili per le virtual network |
| networkbase.tf | Crea le virtual network e le subnet |
| vpn.tf | Crea una VPN punto-sito |
| peering.tf | Crea il peering tra le due vnet tenendo conto della VPN |
| pdc01.tf | Crea server 1|
| pdc02.tf | Crea server 2 |
| ExportedTemplate-ca-vpnpeering-rg.zip | Template JSON di una distribuzione|
| ca-vpnpeering-rg.png | Visualizzazione grafica della distribuzione|
| keyvault.tf | usato per creare la secret che poi sarà la pw del vm|
