# Dockerfile pour n8n avec ffmpeg
# Mise à jour automatique via GitHub Actions

# Argument pour spécifier la version de n8n (par défaut: latest)
ARG N8N_VERSION=latest

# Image de base: n8n officiel
FROM n8nio/n8n:${N8N_VERSION}

# Passer en root pour installer les paquets
USER root

# Installation de ffmpeg et des dépendances
RUN apk add --no-cache ffmpeg

# Retour à l'utilisateur node pour la sécurité
USER node

# Variables d'environnement optionnelles
ENV N8N_TRUST_PROXY=true

# Expose le port 5678 (port par défaut de n8n)
EXPOSE 5678

# Healthcheck pour vérifier que n8n fonctionne
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s \
    CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1
