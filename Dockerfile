# Dockerfile pour n8n avec ffmpeg
# Mise à jour automatique via GitHub Actions
# Utilise un build multi-stage pour installer ffmpeg

# Argument pour spécifier la version de n8n (par défaut: latest)
ARG N8N_VERSION=latest

# Stage 1: Image Alpine pour installer ffmpeg
FROM alpine:latest AS ffmpeg-builder
RUN apk add --no-cache ffmpeg

# Stage 2: Image n8n finale
FROM n8nio/n8n:${N8N_VERSION}

# Passer en root pour copier ffmpeg
USER root

# Copier ffmpeg et ses dépendances depuis le builder
COPY --from=ffmpeg-builder /usr/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ffmpeg-builder /usr/bin/ffprobe /usr/local/bin/ffprobe
COPY --from=ffmpeg-builder /usr/lib /usr/lib

# Retour à l'utilisateur node pour la sécurité
USER node

# Variables d'environnement optionnelles
ENV N8N_TRUST_PROXY=true

# Expose le port 5678 (port par défaut de n8n)
EXPOSE 5678

# Healthcheck pour vérifier que n8n fonctionne
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s \
    CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1
