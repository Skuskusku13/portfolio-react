# Étape 1 : Build de l'application React avec Node.js
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --only=production

COPY . .
RUN npm run build

# Étape 2 : Servir avec Apache (httpd)
FROM httpd:2.4

RUN apt update && apt upgrade -y

# Copier les fichiers compilés du build React vers Apache
COPY --from=builder /app/build /usr/local/apache2/htdocs/

CMD ["httpd", "-D", "FOREGROUND"]
