# Spécifications Fonctionnelles - Évaluation POEI

## Objectif
Développer un système d'intégration et de restitution des commandes d'achat.

## Programme 1: Z_POEC_INTEG_ATH (Intégration)
- Upload fichier TXT (tabulations)
- Parsing des données
- Validation (doublons, existence)
- Insertion en base (mode réel)
- Compte-rendu ALV coloré

## Programme 2: Z_POEC_ATH (Restitution)
- Écran sélection avec matchcode
- Double ALV synchronisé (Header/Item)
- Double-clic pour afficher les postes

## Tables
- ZEKKO_ATH: Entêtes commandes
- ZEKPO_ATH: Postes commandes

## Classe
- ZCL_POEC_ATH: Classe unique (intégration + restitution)