# Projet de Synthèse – Pare-feu DPI

## Objectif

Développer un pare-feu efficace et extensible, destiné à la protection des serveurs privés virtuels (VPS), en combinant un prototype rapide en Python avec une version finale sécurisée en Rust.

---

## Environnement cible

Le pare-feu est conçu pour fonctionner sur une machine virtuelle (VM) ou un serveur dédié tournant sous :
- **Ubuntu Server**

---

## Technologies utilisées

| Composant | Outil/Technologie | Rôle |
|----------|-------------------|------|
| Bash  | `iptables`        | Lecture et redirection des paquets |
| Python | `scapy`, `netfilterqueue` | Prototypage et inspection en profondeur (DPI) |

---

## Description du système

Le pare-feu est un **service système (daemon)** qui tourne en arrière-plan sur le serveur. Il intercepte les paquets entrants à l’aide d’`iptables`, les inspecte via une file de traitement (`NFQUEUE`), puis décide de les **accepter** ou de les **rejeter** selon des règles personnalisées.

---

## Schéma de fonctionnement

```mermaid
flowchart TD
    A[Paquet entrant] --> B[iptables redirige vers NFQUEUE]
    B --> C[Python lit le paquet via NetfilterQueue]
    C --> D[Inspection avec Scapy ou socket brut]
    D --> E{Paquet suspect ?}
    E -- Oui --> F[Rejeter]
    E -- Non --> G[Accepter le paquet]

```

## shema de fonctionnement des classes
```mermaid
graph TD
    A[setup.sh] --> B[Crée l'environnement virtuel Python]
    B --> C[Installe les dépendances]
    C --> F[exec firewall.py -> systemd]
    M --> H[package_handler.py]

    H --> J["Lecture config.json"]
    J --> K[Détection suspects]
    K --> Z[drop si suspect]

    M --> L[logger.py écrit les logs test]
    L --> O[ /var/log/firewall.log ]

    F --> M["iptables -> NFQUEUE"]
```

## test 
## script qui met a jour le systeme avant l'installation des dépendance
![alt text](image-1.png)

## on peut voir a la fin du script que firewall.py est lancé en daemon
![alt text](image.png)

## les logs des paquets vérifié sont dans firewall.log

### apres un ping google (bloqué dans config.json)
![alt text](image-4.png)
![alt text](image-3.png)

### test de commande bloqué (curl)
![alt text](image-6.png)
![alt text](image-5.png)

# Capstone Project – VPS Firewall

## Objective

Develop an efficient and extensible firewall designed to protect Virtual Private Servers (VPS), starting with a quick prototype in Python and evolving into a secure and high-performance version written in Rust.

---

## Target Environment

The firewall is designed to run on a virtual machine (VM) or dedicated server using:
- **Ubuntu Server**

---

## Technologies Used

| Component | Tool/Technology         | Purpose                                   |
|-----------|-------------------------|-------------------------------------------|
| Bash    | `iptables`              | Package redirection and filtering          |
| Python  | `scapy`, `netfilterqueue` | Prototyping and Deep Package Inspection (DPI) |

---

## System Description

The firewall runs as a **background service (daemon)** on the server. It intercepts incoming packages using `iptables`, inspects them through a processing queue (`NFQUEUE`), and decides whether to **accept** or **drop** them based on custom rules.

---

## Flowchart of Operation

```mermaid
flowchart TD
    A[Incoming Package] --> B[iptables forwards to NFQUEUE]
    B --> C[Python reads package via NetfilterQueue]
    C --> D[Inspection with Scapy or raw socket]
    D --> E{Suspicious package?}
    E -- Yes --> F[Drop package and log]
    E -- No --> G[Accept package]
```

## Class Workflow Diagram

```mermaid
graph TD
    A[setup.sh] --> B[Creates Python virtual environment]
    B --> C[Installs dependencies]
    C --> F[Executes firewall.py via systemd]
    M --> H[package_handler.py]

    H --> J["Reads config.json"]
    J --> K[Detects suspicious packets]
    K --> Z[Drop if suspicious]

    M --> L[logger.py writes test logs]
    L --> O[ /var/log/firewall.log ]

    F --> M["iptables -> NFQUEUE"]
```

