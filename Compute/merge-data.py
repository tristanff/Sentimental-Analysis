import pandas as pd
import os

# Chemin des dossiers contenant vos fichiers CSV
folder_paths = ['archive/Data/Set-1/', 'archive/Data/Set-2/']

# Noms des fichiers à fusionner
file_names = [
    'NATO.csv',
    'prayforukraine.csv',
    'russian navy.csv',
    'russianarmy.csv',
    'russianattack.csv',
    'SaveUkraineNow.csv',
    'StopPutinNOW.csv',
    'StopRussia.csv',
    'StopTheWar.csv',
    'ukraineconflict.csv',
    'ukrainecrisis.csv',
    'ukraineunderattack.csv',
    'ukrainewar.csv'
]

# Fonction pour supprimer l'extension .csv
def remove_csv_extension(filename):
    return filename.replace('.csv', '')

# Liste pour stocker les dataframes
dataframes = []

# Parcourir chaque fichier CSV et l'ajouter à la liste des dataframes
for folder_path in folder_paths:
    for file_name in file_names:
        file_path = os.path.join(folder_path, file_name)
        if os.path.exists(file_path):
            try:
                # Lire le fichier CSV en ignorant les lignes avec erreurs
                df = pd.read_csv(file_path, error_bad_lines=False, warn_bad_lines=True)
                # Ajouter une colonne 'subject' avec le nom du fichier sans .csv
                df['subject'] = remove_csv_extension(file_name)
                dataframes.append(df)
            except pd.errors.ParserError:
                print(f"Erreur de parsing dans le fichier: {file_name}. Ligne ignorée.")

# Fusionner tous les dataframes en un seul
final_df = pd.concat(dataframes, ignore_index=True)

# Exporter le dataframe fusionné vers un nouveau fichier CSV
output_file_path = 'merged_data.csv'  # Chemin du fichier de sortie
final_df.to_csv(output_file_path, index=False)

print(f'Les données ont été fusionnées avec succès dans {output_file_path}')


