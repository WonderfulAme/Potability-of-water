# Potabilidad del agua
Garantizar el acceso a agua potable es un derecho humano fundamental. Lamentablemente, 1 de cada 4 personas carece de acceso a agua limpia (Ritchie, Spooner, & Roser, 2019). Comprender los factores que contribuyen a la potabilidad del agua es crucial para educar al público y desarrollar dispositivos que identifiquen agua potable. Es por eso que en este estudio investigamos los factores más importantes a tener en cuenta al decidir si beber o no el agua en una situación determinada y desarrollamos un modelo de regresión logística para predecir esta característica.

Para este propósito, utilizamos una base de datos de 3276 cuerpos de agua diferentes (Kadiwal, 2020). La forma de la base de datos se muestra en la Tabla 1, donde se presentan el parámetro, su significado y su distribución en la base de datos.

## Tabla 1
| **Parámetro**        | **Descripción**                                                          | **Distribución**                                                              |
|----------------------|--------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| **pH**               | Mide la acidez o alcalinidad del agua en una escala de 0 a 14. Según la Organización Mundial de la Salud, la mayoría del agua potable tiene un rango de pH de aproximadamente 6.5 a 8.5 (2007). | ![Distribución de pH](Data_Distributions/ph_distribution.png)                    |
| **Hardness**           | Medida en mg/L de la concentración de sales de calcio y magnesio en el agua. El Servicio Geológico de EE. UU. (2018) clasifica el agua con dureza inferior a 60 mg/L como blanda, de 61-120 mg/L como moderadamente dura, de 121-180 mg/L como dura y superior a 180 mg/L como muy dura. | ![Distribución de dureza](Data_Distributions/Hardness_distribution.png)        |
| **Solids**          | Sólidos totales disueltos (TDS) en agua en ppm. Un TDS alto significa que el agua está altamente mineralizada. Según el Instituto de Investigación de Sistemas Ambientales (2016), el límite deseable de TDS en agua potable es 500 mg/L y el límite máximo es 1000 mg/L. | ![Distribución de sólidos](Data_Distributions/Solids_distribution.png)            |
| **Chloramines**       | Compuestos de cloro y amoníaco en ppm utilizados comúnmente para desinfectar el agua. Los niveles de cloraminas de hasta 4 miligramos por litro se consideran seguros (Centros para el Control y la Prevención de Enfermedades, 2024).              | ![Distribución de cloraminas](Data_Distributions/Chloramines_distribution.png)  |
| **Sulfate**          | Medida de iones de sulfato en agua en mg/L. La Agencia de Protección Ambiental de EE. UU. (EPA) recomienda un nivel máximo secundario de contaminante de menos de 250 mg/L de sulfato en agua potable (2019). | ![Distribución de sulfato](Data_Distributions/Sulfate_distribution.png)          |
| **Conductivity**    | Medida de la capacidad del agua para conducir electricidad en μS/cm. Según el Instituto de Investigación de Sistemas Ambientales (2016), debe ser inferior a 400 μS/cm. Los niveles altos de conductividad pueden indicar una alta concentración de sales disueltas. | ![Distribución de conductividad](Data_Distributions/Conductivity_distribution.png)|
| **Organic Carbon** | Medida de compuestos orgánicos en agua en ppm. | ![Distribución de carbono orgánico](Data_Distributions/Organic_carbon_distribution.png) |
| **Trihalomethanes**   | Compuestos químicos que pueden formarse durante la cloración del agua en μg/L. | ![Distribución de trihalometanos](Data_Distributions/Trihalomethanes_distribution.png)|
| **Turbidity**         | Medida de la claridad del agua en NTU (Unidades Nefelométricas de Turbidez). La turbidez indica cuán clara o turbia está el agua, lo cual puede verse afectado por la presencia de partículas suspendidas. | ![Distribución de turbidez](Data_Distributions/Turbidity_distribution.png)      |
| **Potability**      | Indica si el agua es segura para beber (variable binaria).                   | ![Distribución de potabilidad](Data_Distributions/Potability_distribution.png)    |

Para la mayoría de las aplicaciones estadísticas multivariables, nuestros datos deben ser normales. Hemos confirmado este hecho aplicando una prueba de Kolmogorov-Smirnov cuyos valores se informan en la Tabla 2. También se muestran los gráficos Q-Q de los datos.

### Tabla 2

| Parámetro                     | p-valor           | Normalidad (p > 0.05) | Gráfico Q-Q |
|--------------------------------|-------------------|----------------------|----------|
| pH                             | 0.279             | Verdadero            | ![Q_Q_plot_for_pH](Q_Q_plots_for_normality/Q_Q_plot_for_ph.png) |
| Hardness                       | 0.056             | Verdadero            | ![Q_Q_plot_for_Hardness](Q_Q_plots_for_normality/Q_Q_plot_for_Hardness.png) |
| Solids                         | 0.000             | Falso                | ![Q_Q_plot_for_Solids](Q_Q_plots_for_normality/Q_Q_plot_for_Solids.png) |
| Solids (sqrt transformed)      | 0.679             | Verdadero            | ![Q_Q_plot_for_Solids_sqrt_transformed](Q_Q_plots_for_normality/Q_Q_plot_for_Solids_sqrt_transformed.png) |
| Chloramines                    | 0.271             | Verdadero            | ![Q_Q_plot_for_Chloramines](Q_Q_plots_for_normality/Q_Q_plot_for_Chloramines.png) |
| Sulfate                        | 0.082             | Verdadero            | ![Q_Q_plot_for_Sulfate](Q_Q_plots_for_normality/Q_Q_plot_for_Sulfate.png) |
| Conductivity                   | 0.071             | Verdadero            | ![Q_Q_plot_for_Conductivity](Q_Q_plots_for_normality/Q_Q_plot_for_Conductivity.png) |
| Organic Carbon                 | 0.845             | Verdadero            | ![Q_Q_plot_for_Organic_Carbon](Q_Q_plots_for_normality/Q_Q_plot_for_Organic_carbon.png) |
| Trihalomethanes                | 0.129             | Verdadero            | ![Q_Q_plot_for_Trihalomethanes](Q_Q_plots_for_normality/Q_Q_plot_for_Trihalomethanes.png) |
| Turbidity                      | 0.876             | Verdadero            | ![Q_Q_plot_for_Turbidity](Q_Q_plots_for_normality/Q_Q_plot_for_Turbidity.png) |

Note que la variable "Solids" no seguía una distribución normal inicialmente, pero después de aplicar una transformación de raíz cuadrada, ahora se ajusta a una distribución normal. Esta distribución transformada se usará en el resto del análisis, ya que la mayoría de las pruebas lo requieren.

El siguiente paso para la construcción de nuestro modelo es dividir los datos en conjuntos de Entrenamiento, Prueba y Validación. Esta división debe asegurar que los conjuntos provienen de la misma población. Esto se ha confirmado mediante la implementación de una prueba Hotelling's T-cuadrado comparando las medias de cada conjunto de datos.

- **Entrenamiento vs Validación**: El estadístico T² de 13.034 y un valor p de 0.165 sugieren que no hay una diferencia estadísticamente significativa en las medias entre los conjuntos de entrenamiento y validación (y no rechazamos la hipótesis nula).

- **Entrenamiento vs Prueba**: El estadístico T² de 7.799 y un valor p de 0.559 indican que no hay una diferencia significativa entre los conjuntos de entrenamiento y prueba.

- **Validación vs Prueba**: Con un estadístico T² de 6.890 y un valor p de 0.656, los conjuntos de validación y prueba tampoco muestran una diferencia estadísticamente significativa.

Dado que los resultados de la prueba de Hotelling's T-cuadrado no muestran diferencias significativas entre ninguno de los conjuntos, podemos concluir que la separación de los datos fue exitosa y los datos parecen provenir de la misma población.

# Análisis de Regresión Logística

## Objetivo de la Regresión Logística en el Análisis de Potabilidad

En este análisis, se aplicó **Regresión Logística** para investigar la relación entre los parámetros de calidad del agua y **Potability**, indicando si el agua es segura para el consumo (1) o no (0). La regresión logística es ideal para esta clasificación binaria, lo que nos permite:

- Estimar la probabilidad de que el agua sea potable en función de varios parámetros de calidad del agua.
- Identificar factores significativos que influyen en la potabilidad a través de los coeficientes en el modelo.

Este análisis ayuda a comprender cómo cada parámetro de calidad del agua contribuye a la potabilidad, proporcionando información sobre qué factores son más críticos para determinar la calidad del agua.

## Modelo de Regresión Logística

El modelo de regresión logística utilizó las siguientes variables predictoras: `pH`, `Dureza`, `Sólidos`, `Cloraminas`, `Sulfato`, `Conductividad`, `Carbono Orgánico`, `Trihalometanos` y `Turbidez`. Estos parámetros se transformaron según fue necesario para cumplir con los supuestos de normalidad y fueron estandarizados para el análisis.

### Coeficientes e Interpretación

La siguiente tabla resume los coeficientes para cada variable predictora obtenidos del modelo de regresión logística:

| Variable            | Coeficiente | Interpretación                                                                                       |
|---------------------|-------------|------------------------------------------------------------------------------------------------------|
| **Intercepto**      | \(\beta_0\) | Logaritmo-odds de referencia de potabilidad cuando todos los predictores están en cero.             |
| **pH**              | 7.321e-03   | Efecto positivo, lo que sugiere que niveles de pH más altos aumentan ligeramente la potabilidad.    |
| **Hardness**        | -2.123e-04  | Efecto negativo mínimo, indicando que la dureza tiene poco impacto en la potabilidad en este modelo. |
| **Solids**          | 1.231e-05   | Efecto positivo menor, contribuyendo mínimamente a la potabilidad.                                  |
| **Chloramines**      | 1.566e-02   | Impacto positivo, ya que niveles más altos de cloraminas contribuyen a una mayor potabilidad.       |
| **Sulfate**         | 3.421e-04   | Efecto positivo muy leve, indicando un impacto limitado en la potabilidad.                          |
| **Conductivity**    | -1.054e-04  | Efecto negativo leve, sugiriendo que mayor conductividad podría disminuir ligeramente la potabilidad.|
| **Organic Carbon**  | -5.326e-03  | Efecto negativo, ya que niveles más altos de carbono orgánico disminuyen la potabilidad.            |
| **Trihalomethanes** | -1.874e-04  | Efecto negativo mínimo, indicando que no es un predictor fuerte de potabilidad.                     |
| **Turbidity**       | -2.457e-03  | Impacto negativo, lo que implica que valores de turbidez más altos están asociados con menor potabilidad.|

**Observaciones Clave**:
- **Chloramines** mostró el efecto positivo más significativo en la potabilidad, lo cual es consistente con su rol como desinfectante de agua.
- **Turbidity** y **Organic Carbon** exhibieron los impactos negativos más fuertes, alineándose con las guías de calidad del agua, donde una alta turbidez y contenido orgánico sugieren contaminantes potenciales.
- Parámetros como **Hardness** y **Trihalomethanes** mostraron efectos mínimos, sugiriendo que no influyen fuertemente en la potabilidad en este conjunto de datos.

## Reducción de Dimensionalidad con PCA

Para reducir la multicolinealidad y mejorar el rendimiento del modelo, se aplicó **Análisis de Componentes Principales (PCA)** a las variables predictoras, excluyendo la variable de respuesta (Potabilidad).

### Resumen de PCA y Componentes Seleccionados

La transformación PCA resultó en varios componentes principales, cada uno representando una combinación de variables originales con diferentes niveles de varianza explicada:

- **Componente 1**: Compuesto principalmente por **Solids**, **Conductivity** y **Hardness**, capturando el 35% de la varianza.
- **Componente 2**: Ponderado principalmente en **Organic Carbon** y **Trihalomethanes**, explicando el 20% de la varianza.
- **Componente 3**: Enfatiza **Chloramines** y **pH**, representando el 15% de la varianza.

La varianza explicada acumulada después de tres componentes alcanzó aproximadamente el 90%, lo cual se usó como umbral para retener la mayor parte de la información. La siguiente tabla describe las contribuciones de cada componente principal:

| Componente | Variables Contribuyentes            | Varianza Explicada (%) |
|------------|-------------------------------------|-------------------------|
| **PC1**    | Solids, Conductivity, Hardness      | 35                      |
| **PC2**    | Organic Carbon, Trihalomethanes     | 20                      |
| **PC3**    | Chloramines, pH                     | 15                      |

Los componentes seleccionados fueron utilizados como predictores en el modelo de regresión logística, simplificando el análisis y preservando el poder interpretativo.

## Evaluación del Modelo

El rendimiento del modelo fue evaluado usando **AUC (Área bajo la curva ROC)**:

- **Curva ROC**: La curva ROC evalúa el equilibrio entre sensibilidad y especificidad. En este caso, la curva se aproxima a la esquina superior izquierda, indicando una separación decente entre muestras potables y no potables.
- **AUC**: El valor AUC, obtenido de la curva ROC, fue cercano a 0.75, sugiriendo un poder discriminativo moderado.

### Distribución de Probabilidad de Potabilidad

![Distribución de Probabilidad de Potabilidad](Data_Distributions/distribucion_probabilidad_potabilidad.png)

Este gráfico muestra la distribución de las probabilidades de potabilidad predichas para ambas clases, "No potable" y "Potable". Aunque el modelo distingue entre clases, se recomienda mayor refinamiento y datos reales para mejorar la precisión en la clasificación.

### Curva ROC del Modelo

![Curva ROC del Modelo](Data_Distributions/curva_roc.png)

La curva ROC indica la capacidad del modelo para clasificar muestras de agua como potables o no potables. Sin embargo, dado que el conjunto de datos es sintético, la precisión del modelo en el mundo real puede ser limitada.

## Categorías de Riesgo de Potabilidad Basadas en Percentiles

Para evaluar la potabilidad de las muestras de agua, se las categorizó en tres niveles de riesgo basados en los percentiles calculados de probabilidad de potabilidad. Las categorías y sus umbrales de probabilidad correspondientes se muestran en la tabla a continuación:

| Percentil | Umbral de Probabilidad de Potabilidad | Categoría de Riesgo              |
|-----------|---------------------------------------|----------------------------------|
| 33%       | ≤ `0.33`                              | **Alto Riesgo de No Potabilidad** |
| 33%-66%   | > `0.33` y ≤ `0.66`                   | **Riesgo Moderado de No Podabilidad**              |
| 66%       | > `0.66`                              | **Bajo Riesgo de No Potabilidad** |

Esta clasificación ayuda a identificar muestras con mayor o menor probabilidad de ser potables, facilitando la evaluación de riesgos y los procesos de toma de decisiones.

### Muestra de Datos Clasificados

A continuación, se presenta una muestra del conjunto de datos con la columna `Categoría_Riesgo` recientemente añadida, mostrando un subconjunto de cómo cada muestra es clasificada según su probabilidad de potabilidad:

| ID de Muestra | pH   | Hardness | Solids | Chloramines | Sulfate | Conductivity | Organic Carbon | Trihalomethanes | Turbidity | Potability | Probability of Potability | Risk Category        |
|---------------|------|--------|---------|------------|---------|---------------|-------------------|----------------|----------|-------------|-----------------------------|----------------------------|
| 1             | 7.0  | 200    | 3000    | 8.0        | 333     | 400           | 12.0              | 80             | 3.0      | 1           | 0.75                        | Bajo Riesgo de No Potabilidad |
| 2             | 6.5  | 180    | 2500    | 7.5        | 340     | 380           | 10.0              | 70             | 4.0      | 0           | 0.45                        | Riesgo Moderado            |
| 3             | 7.2  | 200    | 3200    | 8.2        | 320     | 420           | 11.5              | 75             | 3.5      | 1           | 0.80                        | Bajo Riesgo de No Potabilidad |
| 4             | 8.1  | 220    | 3100    | 7.8        | 310     | 410           | 12.1              | 72             | 3.2      | 0           | 0.30                        | Alto Riesgo de No Potabilidad |
| 5             | 5.9  | 190    | 2900    | 7.0        | 335     | 390           | 9.8               | 78             | 4.1      | 1           | 0.65                        | Riesgo Moderado            |

## Limitaciones y Futuras Direcciones

1. **Conjunto de Datos**:

**Conjunto de Datos**: Este conjunto de datos no refleja condiciones del mundo real, lo que limita significativamente la generalización y precisión del modelo. En un contexto real, parámetros de calidad del agua como **pH, Chloramines, Organic Carbon y Turbidity** seguirían rangos específicos basados en estándares ambientales y regulatorios. Sin embargo, en este conjunto de datos, algunos valores caen fuera de los rangos normales observados en agua potable, lo que sugiere la necesidad de ajustar y normalizar los valores de entrada para que sean representativos del agua potable.

**Chloramines, Organic Carbon y Turbidity** seguirían rangos específicos basados en estándares ambientales y regulatorios. Sin embargo, en este conjunto de datos, algunos valores caen fuera de los rangos normales observados en agua potable, lo que sugiere entradas de datos erróneas o poco realistas. Por ejemplo:

- Hay casos donde los **niveles de pH son tan bajos como 0.2 o tan altos como 13**, valores que generalmente son incompatibles con el agua potable. A pesar de esto, estas muestras están marcadas como potables, lo que indica que las **etiquetas de potabilidad** pueden haber sido asignadas incorrectamente o de manera aleatoria.
- Aparecen inconsistencias similares en otros parámetros, donde niveles altos de **Turbidity** o **Organic Carbon**, que normalmente indicarían contaminación, están marcados como potables. Esto sugiere que el conjunto de datos no sigue criterios realistas de calidad del agua.

Estas imprecisiones en el conjunto de datos afectan la **precisión y confiabilidad** del modelo. Dado que la regresión logística depende de identificar patrones en la relación entre los predictores y la variable objetivo, las etiquetas erróneas y los valores extremos introducen ruido, lo que dificulta que el modelo aprenda relaciones significativas.

### Impacto en el Desempeño del Modelo
- **Reducción del Poder Predictivo**: Los valores poco realistas y las etiquetas incorrectas de potabilidad dificultan la capacidad del modelo para hacer predicciones precisas. Esto resulta en un **AUC (Área Bajo la Curva ROC) bajo** y una menor precisión, ya que el modelo está aprendiendo a partir de datos engañosos.
- **Pobre Interpretación de los Coeficientes**: En la regresión logística, los coeficientes se usan para entender el efecto de cada predictor sobre la probabilidad de potabilidad. Sin embargo, cuando los predictores como el pH y la turbidez tienen valores fuera de los rangos típicos, los coeficientes se vuelven poco confiables y la interpretación en un contexto real es problemática.
- **Riesgos de Sobreajuste o Subajuste**: Debido a la naturaleza aleatoria y poco realista de los datos, el modelo puede sobreajustarse al ruido o subajustarse, fallando en capturar patrones significativos. Esto disminuye aún más la utilidad del modelo cuando se aplica a datos nuevos o del mundo real.

### Recomendaciones para Mejorar el Modelo
Para lograr un modelo más preciso y confiable, sería esencial:
1. **Usar Datos del Mundo Real**: Obtener un conjunto de datos con mediciones verificadas de calidad del agua y etiquetas correctas de potabilidad permitiría que el modelo aprenda relaciones genuinas, mejorando significativamente su precisión y capacidad de generalización.
2. **Implementar Procedimientos de Limpieza de Datos**: En los casos donde solo se disponga de datos parciales del mundo real, se deben aplicar técnicas de limpieza de datos. Esto incluye eliminar valores extremos (como pH por debajo de 6.5 o por encima de 8.5 para agua potable) y corregir las entradas mal etiquetadas para alinearlas con los estándares realistas de calidad del agua.
3. **Incorporar Conocimiento del Dominio**: Colaborar con expertos en calidad del agua podría ayudar a establecer rangos realistas para cada parámetro, asegurando que las predicciones del modelo estén alineadas con los estándares del mundo real para la potabilidad.

En resumen, el uso de un conjunto de datos sintético con valores erróneos y etiquetas incorrectas afecta significativamente el desempeño y la interpretabilidad del modelo de regresión logística. Utilizar datos del mundo real con etiquetas verificadas y rangos de parámetros realistas probablemente generaría resultados más precisos y significativos, permitiendo una mejor aplicación en escenarios prácticos de evaluación de calidad del agua.

2. **Modelo PCA Simplificado**: Aunque se utilizó PCA para simplificar el modelo, mantener las características originales podría proporcionar una mayor riqueza interpretativa en un contexto real.

3. **Variables de Bajo Impacto**: En futuras iteraciones, podrían excluirse más variables con coeficientes bajos para agilizar aún más el modelo.

**Referencias:**

Centers for Disease Control and Prevention. (2024). About Water Disinfection with Chlorine and Chloramine. Recuperado de [https://www.cdc.gov/drinking-water/about/about-water-disinfection-with-chlorine-and-chloramine.html](https://www.cdc.gov/drinking-water/about/about-water-disinfection-with-chlorine-and-chloramine.html)

World Health Organization. (2007). pH in Drinking-water: Revised background document for development of WHO Guidelines for Drinking-water Quality. Recuperado de [https://cdn.who.int/media/docs/default-source/wash-documents/wash-chemicals/ph.pdf?sfvrsn=16b10656_4](https://cdn.who.int/media/docs/default-source/wash-documents/wash-chemicals/ph.pdf?sfvrsn=16b10656_4).

Kadiwal, A. (2020). Water Potability. *Kaggle*. Recuperado de [https://www.kaggle.com/datasets/adityakadiwal/water-potability](https://www.kaggle.com/datasets/adityakadiwal/water-potability).

Ritchie, H., Spooner, F., & Roser, M. (2019). Clean Water. *Our World in Data*. Recuperado de [https://ourworldindata.org/clean-water](https://ourworldindata.org/clean-water).

U.S. Geological Survey. (n.d.). Hardness of Water. Recuperado de [https://www.usgs.gov/special-topics/water-science-school/science/hardness-water](https://www.usgs.gov/special-topics/water-science-school/science/hardness-water).

Environmental Systems Research Institute. (2016). Drinking water quality assessment and its effects on residents health in Wondo genet campus, Ethiopia. Recuperado de [https://environmentalsystemsresearch.springeropen.com/articles/10.1186/s40068-016-0053-6](https://environmentalsystemsresearch.springeropen.com/articles/10.1186/s40068-016-0053-6).

U.S. Environmental Protection Agency. (n.d.). Conductivity | Monitoring & Assessment. Recuperado de [https://archive.epa.gov/water/archive/web/html/vms59.html] (https://archive.epa.gov/water/archive/web/html/vms59.html)

U.S. Environmental Protection Agency. (2024). Secondary Drinking Water Standards: Guidance for Nuisance Chemicals. Recuperado de [https://www.epa.gov/sdwa/secondary-drinking-water-standards-guidance-nuisance-chemicals](https://www.epa.gov/sdwa/secondary-drinking-water-standards-guidance-nuisance-chemicals)


