# 📦 POEI EVALUATION ATH

> **Évaluation POEI - Intégration et Restitution de Commandes d'Achat**  
> Architecture Orientée Objet (ABAP OOP) - SAP ECC 6.0

---

## 📋 Table des Matières

- [Contexte](#contexte)
- [Objectifs](#objectifs)
- [Architecture Technique](#architecture-technique)
- [Prérequis](#prérequis)
- [Structure du Projet](#structure-du-projet)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Tests et Validation](#tests-et-validation)
- [Standards et Nomenclature](#standards-et-nomenclature)
- [Auteur](#auteur)

---

## 🎯 Contexte

Projet d'évaluation Alliance4U visant à développer une solution complète d'intégration et de restitution de données de commandes d'achat provenant d'un applicatif externe.

**Périmètre fonctionnel :**
- Import de fichiers TXT (format tabulé) vers base de données SAP
- Validation des données et détection d'anomalies
- Restitution interactive avec double ALV synchronisé

---

## 🎯 Objectifs

### Programme 1 : Intégration (`Z_POEC_INTEG_ATH`)
- ✅ Lecture fichier TXT local (séparateur tabulation)
- ✅ Parsing et validation des données (entêtes + postes)
- ✅ Détection des doublons de poste (EBELP)
- ✅ Insertion en base de données (ZEKKO_ATH / ZEKPO_ATH)
- ✅ Mode test (simulation sans commit)
- ✅ Compte-rendu coloré (vert = OK, rouge = KO)

### Programme 2 : Restitution (`Z_POEC_ATH`)
- ✅ Écran de sélection avec matchcode
- ✅ Validation de l'existence des documents
- ✅ Double ALV avec splitter (entêtes ↔ postes)
- ✅ Événement double-clic pour afficher les postes
- ✅ Messages d'erreur personnalisés

---

## 🏗️ Architecture Technique

### Modèle de Données

```
ZEKKO_ATH (Entêtes de Commande)
├── MANDT    [CLNT]  Client (clé)
├── EBELN    [CHAR]  Numéro de document (clé)
├── BSTYP    [CHAR]  Catégorie de document
├── AEDAT    [DATS]  Date de modification
├── ERNAM    [CHAR]  Créé par
└── WAERS    [CUKY]  Devise

ZEKPO_ATH (Postes de Commande)
├── MANDT    [CLNT]  Client (clé)
├── EBELN    [CHAR]  Numéro de document (clé)
├── EBELP    [NUMC]  Numéro de poste (clé)
├── MATNR    [CHAR]  Numéro article
├── WERKS    [CHAR]  Site
├── MENGE    [QUAN]  Quantité commandée
├── NETPR    [CURR]  Prix net
├── NETWR    [CURR]  Valeur nette
└── MEINS    [UNIT]  Unité de mesure
```

### Architecture OOP

```
📦 Z_POEC_INTEG_ATH
└── ZCL_POEC_INTEG_ATH
    ├── upload_file()           → GUI_UPLOAD
    ├── parse_file_content()    → Split par TAB
    ├── validate_header()       → Contrôle format entête
    ├── validate_items()        → Détection doublon EBELP
    ├── save_to_database()      → INSERT (si test_mode = '')
    └── display_report()        → ALV compte-rendu

📦 Z_POEC_ATH
├── ZCL_POEC_DISPLAY_ATH
│   ├── validate_selection()    → Vérification EBELN existe
│   ├── get_header_data()       → SELECT ZEKKO_ATH
│   ├── get_item_data()         → SELECT ZEKPO_ATH
│   └── display_dual_alv()      → Splitter + 2 grilles ALV
│
└── ZCL_POEC_ALV_HANDLER_ATH (event handler)
    └── on_double_click()       → Rafraîchissement ALV items
```

---

## ⚙️ Prérequis

- **SAP ECC 6.0** ou supérieur
- **Autorisation SE11** (création tables)
- **Autorisation SE24** (création classes)
- **Autorisation SE80** (création programmes)
- **Package Z** disponible (ou $TMP pour tests)

---

## 📁 Structure du Projet

```
POEI_EVALUATION_ATH/
├── README.md                    # Documentation principale
├── src/
│   ├── zcl_poec_integ_ath.abap # Classe intégration
│   ├── zcl_poec_display_ath.abap # Classe restitution
│   └── zcl_poec_alv_handler_ath.abap # Handler événements
├── tables/
│   ├── ZEKKO_ATH.txt           # Définition table entêtes
│   └── ZEKPO_ATH.txt           # Définition table postes
├── docs/
│   ├── spec.md                 # Spécification fonctionnelle
│   └── screenshots/            # Captures d'écran
└── tests/
    └── fichier_test.txt        # Fichier de test fourni
```

---

## 🚀 Installation

### 1️⃣ Création des Tables (SE11)

```abap
" ZEKKO_ATH
" Delivery Class: A (Application table)
" Clés: MANDT + EBELN

" ZEKPO_ATH
" Delivery Class: A (Application table)
" Clés: MANDT + EBELN + EBELP
```

**Fichiers de référence :**
- `tables/ZEKKO_ATH.txt`
- `tables/ZEKPO_ATH.txt`

### 2️⃣ Création des Classes (SE24)

```
ZCL_POEC_INTEG_ATH    → Classe d'intégration
ZCL_POEC_DISPLAY_ATH  → Classe de restitution
ZCL_POEC_ALV_HANDLER_ATH → Handler événements ALV
```

### 3️⃣ Création des Programmes (SE38)

```
Z_POEC_INTEG_ATH  → Programme d'intégration
Z_POEC_ATH        → Programme de restitution
```

### 4️⃣ Transport

- Créer un OT (SE10)
- Enregistrer tous les objets dans l'OT
- Libérer l'OT après validation

---

## 💻 Utilisation

### Programme d'Intégration

1. **Lancer SE38** → `Z_POEC_INTEG_ATH`
2. **Sélectionner le fichier** via aide à la saisie
3. **Cocher "Test mode"** pour simulation (optionnel)
4. **Exécuter (F8)**

**Résultat attendu :**
```
Report Z_POEC_INTEG_ATH
─────────────────────────
4000000000  created
4030000000  created
4500018198  created
4500018199  created
4500018215  not created  [ROUGE - doublon EBELP]
4600000120  created
```

### Programme de Restitution

1. **Lancer SE38** → `Z_POEC_ATH`
2. **Saisir critères :**
   - Purchasing Document (avec matchcode sur ZEKKO_ATH)
   - Material (optionnel)
3. **Exécuter (F8)**
4. **Double-clic sur une ligne** → Affichage postes à droite

**Écran résultat :**
```
┌─────────────────────┬──────────────────────┐
│ ALV HEADER (gauche) │ ALV ITEMS (droite)   │
│                     │                      │
│ EBELN | BSTYP | ... │ EBELN | EBELP | ...  │
│ ───────────────────  │ ──────────────────── │
│ 400... | F | ...    │ (vide initialement)  │
│ 403... | F | ...    │                      │
│ 450... | F | ...    │ ← Double-clic ici    │
│                     │ → Postes affichés    │
└─────────────────────┴──────────────────────┘
```

---

## ✅ Tests et Validation

### Tests Programme d'Intégration

| Test | Critère | Résultat Attendu |
|------|---------|------------------|
| Import fichier OK | Fichier conforme | Toutes commandes "created" (vert) |
| Import avec doublon EBELP | Commande 4500018215 | Ligne rouge "not created" |
| Mode test activé | Checkbox coché | Aucune insertion en BDD |
| Relance après import | Même fichier | Toutes commandes en rouge (déjà existantes) |

### Tests Programme de Restitution

| Test | Critère | Résultat Attendu |
|------|---------|------------------|
| Saisie MATNR 100-121 | Material existe | Affichage commandes filtrées |
| Saisie EBELN inexistant | Ex: "123" | Message erreur : "Purchasing document 123 not found..." |
| Double-clic sur entête | Sélection ligne | ALV postes se remplit à droite |
| Écran vide | Aucun critère | Affichage toutes les entêtes |

### Vérification SE16N

```sql
-- Vérifier insertion ZEKKO_ATH
SE16N → ZEKKO_ATH → Display

-- Vérifier insertion ZEKPO_ATH
SE16N → ZEKPO_ATH → Display

-- ⚠️ Attention format date AEDAT : YYYYMMDD (ex: 20180430)
```

---

## 📐 Standards et Nomenclature

### Conventions de Nommage

| Type | Préfixe | Exemple |
|------|---------|---------|
| Variable globale (table) | `gt_` | `gt_header_data` |
| Variable globale (structure) | `gs_` | `gs_header` |
| Variable globale (simple) | `gv_` | `gv_file_path` |
| Variable locale (table) | `lt_` | `lt_items` |
| Variable locale (structure) | `ls_` | `ls_line` |
| Variable locale (simple) | `lv_` | `lv_index` |
| Field-Symbol global | `<fsg_` | `<fsg_line>` |
| Field-Symbol local | `<fsl_` | `<fsl_item>` |
| Classe | `zcl_` | `zcl_poec_integ_ath` |
| Programme | `z_` | `z_poec_ath` |
| Table Z | `z` | `zekko_ath` |

### Standards Techniques

- ✅ **Commentaires** : 1ère personne, en français
- ✅ **Pas de WRITE** ni **BREAK-POINT** dans le code final
- ✅ **Débogage** : uniquement via debugger SAP
- ✅ **Variables locales** privilégiées sur globales
- ✅ **Exceptions** class-based uniquement
- ✅ **LOOP max 2 niveaux** d'imbrication

---

## 👨‍💻 Auteur

**Alain TARDIF**  
Consultant ABAP en formation - AELION  
Trigramme : **ATH**

**Évaluation :** POEI SAP ABAP  
**Date :** Janvier 2026  
**Formateur :** Centre de Compétences Alliance4U

---

## 📄 License

Ce projet est à usage pédagogique dans le cadre de la formation POEI ABAP.

---

## 🔗 Références

- [Clean ABAP](https://github.com/SAP/styleguides/blob/main/clean-abap/CleanABAP.md)
- [SAP ABAP Development User Guide](https://help.sap.com/docs)
- Standards Alliance4U (document interne)

---

**Version :** 1.0.0  
**Dernière mise à jour :** 05/01/2026