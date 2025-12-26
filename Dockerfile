# Dockerfile pour n8n avec ffmpeg
# Mise a jour automatique via GitHub Actions

# Argument pour specifier la version de n8n (par defaut: latest)
ARG N8N_VERSION=latest

# Image de base: n8n officiel
FROM n8nio/n8n:${N8N_VERSION}

# Passer en root pour installer les paquets
USER root

# Installation de ffmpeg et des dependances
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Retour a l'utilisateur node pour la securite
USER node

# Variables d'environnement optionnelles
ENV N8N_TRUST_PROXY=true

# Expose le port 5678 (port par defaut de n8n)
EXPOSE 5678

# Healthcheck pour verifier que n8n fonctionne
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s \
    CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1
