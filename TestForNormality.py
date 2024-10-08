from DataCleaning import data_na
import statsmodels.api as sm
import matplotlib.pyplot as plt
import os
import numpy as np
import seaborn as sns
import scipy.stats as stats

def test_normality_of_columns(data):
    alpha = 0.05  # significance level
    results = {}
    
    # Create directory if it doesn't exist
    output_dir = 'Q_Q_plots_for_normality'
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    for column in data.columns:
        normalized_data = (data[column] - data[column].mean()) / data[column].std()

        _, p_value = stats.kstest(normalized_data, 'norm')
        
        results[column] = p_value > alpha
        
        print(f'{column}, p-value: {p_value}')
    
        # Set the aesthetic style of the plots
        sns.set(style="whitegrid")

        # Create the Q-Q plot with seaborn
        fig = plt.figure()
        ax = fig.add_subplot(111)
        sm.qqplot(normalized_data, line='s', ax=ax)
        ax.set_title(f'Q-Q plot for {column}', fontsize=14)
        ax.get_lines()[0].set_color('lightblue')  # Points
        ax.get_lines()[1].set_color('lightgreen')  # Line
        
        plt.savefig(os.path.join(output_dir, f'Q_Q_plot_for_{column}.png'))
        plt.close()
    
    return results

test_normality_of_columns(data_na)

def test_sqrt_transformed_column(data, column_name):
    
    sqrt_transformed = np.sqrt(data[column_name])
    normalized_sqrt_transformed = (sqrt_transformed - sqrt_transformed.mean()) / sqrt_transformed.std()

    _, p_value_sqrt = stats.kstest(normalized_sqrt_transformed, 'norm')

    print(f'{column_name} (sqrt-transformed), p-value: {p_value_sqrt}')

    # Set the aesthetic style of the plots
    sns.set(style="whitegrid")

    # Create the Q-Q plot with seaborn
    fig = plt.figure()
    ax = fig.add_subplot(111)
    sm.qqplot(normalized_sqrt_transformed, line='s', ax=ax)
    ax.set_title(f'Q-Q plot for {column_name} sqrt transformed', fontsize=14)
    ax.get_lines()[0].set_color('lightblue')  # Points
    ax.get_lines()[1].set_color('lightgreen')  # Line

    output_dir = 'Q_Q_plots_for_normality'
    plt.savefig(os.path.join(output_dir, f'Q_Q_plot_for_{column_name}_sqrt_transformed.png'))
    plt.close()

test_sqrt_transformed_column(data_na, 'Solids')
