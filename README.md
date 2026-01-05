# POEI Évaluation ATH - Gestion Commandes Achat

## Description
Projet d'évaluation POEI - Développement ABAP OO pour la gestion des commandes d'achat.

## Architecture
```
POEI_EVALUATION_ATH/
├── src/
│   ├── classes/
│   │   └── zcl_poec_ath.abap      # Classe unique
│   ├── programs/
│   │   ├── z_poec_integ_ath.abap  # Programme intégration
│   │   └── z_poec_ath.abap        # Programme restitution
│   └── tables/
│       ├── zekko_ath.txt          # Table entêtes
│       └── zekpo_ath.txt          # Table postes
├── docs/
│   └── specifications.md
└── README.md
```

## Fonctionnalités

### Intégration (Z_POEC_INTEG_ATH)
- Upload fichier TXT
- Mode test / Mode réel
- Validation données
- Détection doublons
- Compte-rendu coloré

### Restitution (Z_POEC_ATH)
- Double ALV (Header / Item)
- Matchcode sur EBELN
- Double-clic synchronisé
- Filtrage par Material

## Auteur
Alain Tardif - Formation POEI ABAP 2025