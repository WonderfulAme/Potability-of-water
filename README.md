# Potability of water
Ensuring access to potable water is a fundamental human right. Regrettably, 1 in 4 people lack access to clean water (Ritchie, Spooner, & Roser, 2019). Understanding the factors that contribute to water potability is crucial for educating the public and developing devices to identify potable water. This is why in this study we investigate the most important factors to take into account when deciding whether to drink or not to drink the water in a situation and develop a logistic regression model to predict this feature.

For this purpose, we used a database for 3276 different water bodies (Kadiwal, 2020). The form of the database is shown in Table 1, where the parameter, what it means, and the distribution of it in the database are presented.

## Table 1
| **Parameter**        | **Description**                                                          | **Distribution**                                                              |
|----------------------|--------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| **pH**               | Measures the acidity or alkalinity of water on a scale from 0 to 14. According to the World Health Organization, most drinking water has a pH range of approximately 6.5 to 8.5 (2007). | ![pH Distribution](Data_Distributions/pH_distribution.png)                    |
| **Hardness**          | Measure in mg/L of the concentration of calcium and magnesium salts in water. The U.S. Geological Survey (2018) classifies water with hardness less than 60 mg/L as soft, 61-120 mg/L as moderately hard, 121-180 mg/L as hard, and more than 180 mg/L as very hard. | ![Hardness Distribution](Data_Distributions/Hardness_distribution.png)        |
| **Solids**            | Total dissolved solids (TDS) in water in ppm. A high TDS means the water is highly mineralized. According to the Environmental Systems Research Institute (2016), the desirable limit for TDS in potable water is 500 mg/L and the maximum limit is 1000 mg/L. | ![Solids Distribution](Data_Distributions/Solids_distribution.png)            |
| **Chloramines**       | Compounds of chlorine and ammonia in ppm used commonly to disinfect water. Chloramine levels up to 4 milligrams per liter are considered safe. (Centers for Disease Control and Prevention, 2024)              | ![Chloramines Distribution](Data_Distributions/Chloramines_distribution.png)  |
| **Sulfate**           | Measure of sulfate ions in water in mg/L. The U.S. Environmental Protection Agency (EPA) recommends a secondary maximum contaminant level of less than 250 mg/L for sulfate in drinking water (2019). | ![Sulfate Distribution](Data_Distributions/Sulfate_distribution.png)          |
| **Conductivity**      | Measure of water's ability to conduct electricity in μS/cm. According to the Environmental Systems Research Institute (2016) it should be less than 400 μS/cm. High conductivity levels may indicate a high concentration of dissolved salts. | ![Conductivity Distribution](Data_Distributions/Conductivity_distribution.png)|
| **Organic Carbon**    | Measure of organic compounds in water in ppm. | ![Organic Carbon Distribution](Data_Distributions/Organic_Carbon_distribution.png) |
| **Trihalomethanes**   | Chemical compounds that can form during water chlorination in μg/L. | ![Trihalomethanes Distribution](Data_Distributions/Trihalomethanes_distribution.png)|
| **Turbidity**         | Measure of water clarity in NTU (Nephelometric Turbidity Units). Turbidity indicates how clear or cloudy water is, which can be affected by the presence of suspended particles. | ![Turbidity Distribution](Data_Distributions/Turbidity_distribution.png)      |
| **Potability**        | Indicates if water is safe to drink (binary variable).                   | ![Potability Distribution](Data_Distributions/Potability_distribution.png)    |

For most multivariable statistic applications, our data must be normal. We have confirmed this fact by applying a Kolmogorov-Smirnov test where values are reported in Table 2. Q-Q plots of the data are also shown.

### Table 2

| Parameter                     | p-value           | Normality (p > 0.05) | Q-Q Plot |
|--------------------------------|-------------------|----------------------|----------|
| pH                             | 0.279             | True                 | ![Q_Q_plot_for_pH](Q_Q_plots_for_normality/Q_Q_plot_for_pH.png) |
| Hardness                       | 0.056             | True                 | ![Q_Q_plot_for_Hardness](Q_Q_plots_for_normality/Q_Q_plot_for_Hardness.png) |
| Solids                         | 0.000             | False                | ![Q_Q_plot_for_Solids](Q_Q_plots_for_normality/Q_Q_plot_for_Solids.png) |
| Solids (sqrt transformed)      | 0.679             | True                 | ![Q_Q_plot_for_Solids_sqrt_transformed](Q_Q_plots_for_normality/Q_Q_plot_for_Solids_sqrt_transformed.png) |
| Chloramines                    | 0.271             | True                 | ![Q_Q_plot_for_Chloramines](Q_Q_plots_for_normality/Q_Q_plot_for_Chloramines.png) |
| Sulfate                        | 0.082             | True                 | ![Q_Q_plot_for_Sulfate](Q_Q_plots_for_normality/Q_Q_plot_for_Sulfate.png) |
| Conductivity                   | 0.071             | True                 | ![Q_Q_plot_for_Conductivity](Q_Q_plots_for_normality/Q_Q_plot_for_Conductivity.png) |
| Organic Carbon                 | 0.845             | True                 | ![Q_Q_plot_for_Organic_Carbon](Q_Q_plots_for_normality/Q_Q_plot_for_Organic_Carbon.png) |
| Trihalomethanes                | 0.129             | True                 | ![Q_Q_plot_for_Trihalomethanes](Q_Q_plots_for_normality/Q_Q_plot_for_Trihalomethanes.png) |
| Turbidity                      | 0.876             | True                 | ![Q_Q_plot_for_Turbidity](Q_Q_plots_for_normality/Q_Q_plot_for_Turbidity.png) |

Note that the "Solids" variable did not follow a normal distribution initially, but after applying a square root transformation, it now conforms to a normal distribution. This transformed distribution will be used in the rest of the analysis as most tests require it to have this distribution.
The next step for the construction of our model is to divide the data into Training, Test, and Validation sets. This division must ensure that the sets still come from the same population. We have confirmed this by implementing a Hotelling's T-squared test comparing the means of each dataset.

- **Train vs Validation**: The T²-statistic of 13.034 and a p-value of 0.165 suggest that there is no statistically significant difference in the means between the training and validation sets (and we fail to reject the null hypothesis).

- **Train vs Test**: The T²-statistic of 7.799 and a p-value of 0.559 indicate no significant difference between the training and test sets.

- **Validation vs Test**: With a T²-statistic of 6.890 and a p-value of 0.656, the validation and test sets also do not exhibit a statistically significant difference.

Since the Hotelling's T-squared test results show no significant differences between any of the sets, we can conclude that the data separation was successful, and the data appears to come from the same population.


**References:**

Centers for Disease Control and Prevention. (2024). About Water Disinfection with Chlorine and Chloramine. Retrived from [https://www.cdc.gov/drinking-water/about/about-water-disinfection-with-chlorine-and-chloramine.html](https://www.cdc.gov/drinking-water/about/about-water-disinfection-with-chlorine-and-chloramine.html)

World Health Organization. (2007). pH in Drinking-water: Revised background document for development of WHO Guidelines for Drinking-water Quality. Retrieved from [https://cdn.who.int/media/docs/default-source/wash-documents/wash-chemicals/ph.pdf?sfvrsn=16b10656_4](https://cdn.who.int/media/docs/default-source/wash-documents/wash-chemicals/ph.pdf?sfvrsn=16b10656_4).

Kadiwal, A. (2020). Water Potability. *Kaggle*. Retrieved from [https://www.kaggle.com/datasets/adityakadiwal/water-potability](https://www.kaggle.com/datasets/adityakadiwal/water-potability).

Ritchie, H., Spooner, F., & Roser, M. (2019). Clean Water. *Our World in Data*. Retrieved from [https://ourworldindata.org/clean-water](https://ourworldindata.org/clean-water).

U.S. Geological Survey. (n.d.). Hardness of Water. Retrieved from [https://www.usgs.gov/special-topics/water-science-school/science/hardness-water](https://www.usgs.gov/special-topics/water-science-school/science/hardness-water).

Environmental Systems Research Institute. (2016). Drinking water quality assessment and its effects on residents health in Wondo genet campus, Ethiopia. Retrieved from [https://environmentalsystemsresearch.springeropen.com/articles/10.1186/s40068-016-0053-6](https://environmentalsystemsresearch.springeropen.com/articles/10.1186/s40068-016-0053-6).

U.S. Environmental Protection Agency. (n.d.). Conductivity | Monitoring & Assessment. Retrieved from [https://archive.epa.gov/water/archive/web/html/vms59.html] (https://archive.epa.gov/water/archive/web/html/vms59.html)

U.S. Environmental Protection Agency. (2024). Secondary Drinking Water Standards: Guidance for Nuisance Chemicals. Retrieved from [https://www.epa.gov/sdwa/secondary-drinking-water-standards-guidance-nuisance-chemicals](https://www.epa.gov/sdwa/secondary-drinking-water-standards-guidance-nuisance-chemicals)
