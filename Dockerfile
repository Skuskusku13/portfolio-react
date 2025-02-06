# Étape 1 : Build de l'application React avec Node.js
FROM node:20 AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build

# Étape 2 : Servir avec Apache (httpd)
FROM httpd:2.4

ENV APACHE_LOG_DIR=/var/log/apache2

# Copier la configuration du VirtualHost
COPY 000-default.conf /usr/local/apache2/conf/extra/000-default.conf

# Configurer le VirtualHost dans le fichier de configuration principal Apache
RUN echo "Include /usr/local/apache2/conf/extra/000-default.conf" >> /usr/local/apache2/conf/httpd.conf

# S'assurer que le module rewrite est activé
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf

COPY --from=builder /app/build /usr/local/apache2/htdocs/

CMD ["httpd", "-D", "FOREGROUND"]
