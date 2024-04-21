# Utiliser Debian comme image de base
FROM python:3

RUN pip install --no-cache-dir --upgrade pip

RUN pip install flask pysentimiento

# Cloner le dépôt Git
RUN git clone https://github.com/tristanff/Sentimental-Analysis

# Définir le répertoire de travail
WORKDIR /Sentimental-Analysis/Compute

# Exécuter le script Python
CMD ["python3", "server.py"]
