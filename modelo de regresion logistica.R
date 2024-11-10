# Cargar las librerías necesarias
library(dplyr)
library(ggplot2)
library(MASS)
library(lava)
library(caret)
library(pROC) 
library(Metrics)

#cambiar el camino al archivo dependiendo de donde lo guardaras
water_data <- read.csv("D:/IngenieriaMatematica/Semestre5/Estadistica2/Proyecto/water_potability.csv")

View(water_data)

# Transformación de la variable "Solids" (raíz cuadrada) para cumplir la normalidad
water_data$Solids <- sqrt(water_data$Solids)

# Imputación de valores faltantes con el promedio de cada columna
water_data <- water_data %>%
  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .)))

# División de los datos en conjuntos de entrenamiento, prueba y validación
set.seed(123)
trainIndex <- createDataPartition(water_data$Potability, p = 0.6, list = FALSE)
train_data <- water_data[trainIndex, ]
temp_data <- water_data[-trainIndex, ]
# División entre prueba y validación (50-50 de los datos restantes)
testIndex <- createDataPartition(temp_data$Potability, p = 0.5, list = FALSE)
test_data <- temp_data[testIndex, ]
validation_data <- temp_data[-testIndex, ]

# Ajuste del modelo de regresión logística en el conjunto de entrenamiento
model <- glm(Potability ~ ph + Hardness + Solids + Chloramines + Sulfate + Conductivity + Organic_carbon + Trihalomethanes + Turbidity, 
             data = train_data, family = binomial(link = "logit"))

# Resumen del modelo
summary(model)

# Extraer los coeficientes del modelo (opcional)
coeficientes <- coef(model)
print(coeficientes)

# Calcular las probabilidades utilizando predict() en lugar de una función personalizada
train_data$Probability_of_Potability <- predict(model, type = "response")

# Verificar el dataframe con la nueva columna de probabilidades
View(train_data)

# Predicciones en los conjuntos de prueba y validación
test_data$Probability_of_Potability <- predict(model, newdata = test_data, type = "response")
validation_data$Probability_of_Potability <- predict(model, newdata = validation_data, type = "response")


# Unir los dataframes en uno solo
water_potability <- rbind(train_data, test_data, validation_data)


# Categorización en base a percentiles (opcional)
percentile_33 <- quantile(water_potability$Probability_of_Potability, 0.33)
percentile_66 <- quantile(water_potability$Probability_of_Potability, 0.66)

water_potability <- water_potability %>%
  mutate(Risk_Category = case_when(
    Probability_of_Potability <= percentile_33 ~ "Alto riesgo de no potabilidad",
    Probability_of_Potability > percentile_33 & Probability_of_Potability <= percentile_66 ~ "Moderado",
    Probability_of_Potability > percentile_66 ~ "Bajo riesgo de no potabilidad"
  ))

View(water_potability)


# Evaluación del desempeño del modelo: matriz de confusión y precisión
predicted_classes <- ifelse(test_data$Probability_of_Potability > 0.5, 1, 0)
conf_matrix <- table(test_data$Potability, predicted_classes)
sensitivity <- conf_matrix[2, 2] / sum(conf_matrix[2, ])
specificity <- conf_matrix[1, 1] / sum(conf_matrix[1, ])
precision <- conf_matrix[2, 2] / sum(conf_matrix[, 2])
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste("Sensibilidad en el conjunto de prueba:", sensitivity))
print(paste("Especificidad en el conjunto de prueba:", specificity))
print(paste("Precisión (Valor predictivo positivo) en el conjunto de prueba:", precision))
print(paste("Precisión del modelo en el conjunto de prueba:", accuracy))

# Visualización de la distribución de las probabilidades
ggplot(water_potability, aes(x = Probability_of_Potability, fill = Risk_Category)) +
  geom_histogram(binwidth = 0.05) +
  labs(title = "Distribución de la probabilidad de potabilidad en el conjunto de prueba", x = "Probabilidad de Potabilidad", y = "Frecuencia") +
  theme_minimal()

# curva ROC y AUC para evaluar la capacidad del modelo de distinguir entre clases
roc_curve <- roc(test_data$Potability, test_data$Probability_of_Potability)
plot(roc_curve, main = "Curva ROC para el conjunto de prueba")
auc_value <- auc(roc_curve)
print(paste("AUC del modelo en el conjunto de prueba:", auc_value))

# El puntaje F1 para mirar la efectividad del modleo en clasificar correctamente
f1 <- f1_score(as.factor(test_data$Potability), as.factor(predicted_classes))
print(paste("F1 Score en el conjunto de prueba:", f1))
