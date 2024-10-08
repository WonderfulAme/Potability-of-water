import pandas as pd
import numpy as np

def remove_na(data):
    data_clean = data.dropna()
    return data_clean

data = pd.read_csv('water_potability.csv') 
data_na = remove_na(data)


def sqrt_solids(data):
    m_data = data.copy()
    m_data['Solids'] = np.sqrt(m_data["Solids"])
    return m_data

m_data = sqrt_solids(data_na)

def normalize_columns(data):
    normalized_data = data.copy()
    for column in data.columns:
        normalized_data[column] = (data[column] - data[column].mean()) / data[column].std()
    return normalized_data

data_normalized = normalize_columns(m_data)