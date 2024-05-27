# Utiliser Debian comme image de base
FROM python:3

# Mettre à jour pip
RUN pip install --no-cache-dir --upgrade pip

# Installer les dépendances
RUN pip install flask pysentimiento

# Créer un répertoire pour le code source
RUN mkdir -p /Sentimental-Analysis/Compute

# Copier les fichiers locaux dans l'image Docker
COPY . /Sentimental-Analysis/Compute

# Définir le répertoire de travail
WORKDIR /Sentimental-Analysis/Compute
# Exécuter le script Python
CMD ["python3", "process.py"]

