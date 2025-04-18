# Projet de Synthèse – Pare-feu pour VPS

## Objectif

Développer un pare-feu efficace et extensible, destiné à la protection des serveurs privés virtuels (VPS), en combinant un prototype rapide en Python avec une version finale sécurisée en Rust.

---

## Environnement cible

Le pare-feu est conçu pour fonctionner sur une machine virtuelle (VM) ou un serveur dédié tournant sous :
- **Ubuntu Server**
- **NixOS**  
(selon les besoins spécifiques du déploiement)

---

## Technologies utilisées

| Composant | Outil/Technologie | Rôle |
|----------|-------------------|------|
| 🐚 Bash  | `iptables`        | Lecture et redirection des paquets |
| 🐍 Python | `scapy`, `netfilterqueue` | Prototypage et inspection en profondeur (DPI) |
| 🦀 Rust   | `libnetfilter_queue`, `tokio` | Implémentation finale, plus rapide et sécurisée |

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
    E -- Oui --> F[Rejeter + enregistrer dans les logs]
    E -- Non --> G[Accepter le paquet]

