FROM nginx:alpine

# Landing Page (Repo-Wurzel)
COPY index.html /usr/share/nginx/html/index.html
COPY design/    /usr/share/nginx/html/design/
COPY assets/    /usr/share/nginx/html/assets/

# Editor (Submodul) unter /editor/ ausliefern
COPY makerSpaceOS-Editor/ /usr/share/nginx/html/editor/

# nginx-Konfiguration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
