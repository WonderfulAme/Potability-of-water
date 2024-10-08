import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import os

data = pd.read_csv('water_potability.csv')

output_dir = 'Data_Distributions'
os.makedirs(output_dir, exist_ok=True)

for column in data.columns:
    if column != 'Potability':
        plt.figure(figsize=(10, 6))
        
        # Plot KDE for all data
        sns.kdeplot(data[column], color='blue', label='All Data', fill=True, alpha=0.05)
        
        # Plot KDE for potable water
        sns.kdeplot(data[data['Potability'] == 1][column], color='green', label='Potable Water', fill=True, alpha=0.05)
        
        # Plot KDE for non-potable water
        sns.kdeplot(data[data['Potability'] == 0][column], color='red', label='Non-Potable Water', fill=True, alpha=0.05)
        
        plt.title(f'Distribution of {column}')
        plt.xlabel(column)
        plt.ylabel('Density')
        plt.legend()
        plt.savefig(os.path.join(output_dir, f'{column}_distribution.png'))
        plt.close()

# Plot bar graph for Potability column
plt.figure(figsize=(10, 6))
sns.countplot(x='Potability', data=data, palette=['lightblue', 'lightgreen'], hue='Potability', dodge=False)
plt.title('Distribution of Potability')
plt.xlabel('Potability')
plt.ylabel('Count')
plt.xticks([0, 1], ['Non-Potable', 'Potable'])
plt.legend([],[], frameon=False)
plt.savefig(os.path.join(output_dir, 'Potability_distribution.png'))
plt.close()
