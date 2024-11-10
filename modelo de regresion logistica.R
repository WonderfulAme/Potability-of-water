# Cargar las librerías necesarias
library(dplyr)
library(ggplot2)
library(MASS)
library(caret)
library(pROC) 
library(Metrics)

water_data <- read.csv("~/Desktop/universidad/quinto semestre/estadistica 2/poryecto final/water_potability.csv")
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

# Predicciones en los conjuntos de prueba y validación
test_data$predicted_prob <- predict(model, newdata = test_data, type = "response")
validation_data$predicted_prob <- predict(model, newdata = validation_data, type = "response")

# Categorización en base a percentiles (opcional)
percentile_33 <- quantile(test_data$predicted_prob, 0.33)
percentile_66 <- quantile(test_data$predicted_prob, 0.66)

test_data <- test_data %>%
  mutate(Risk_Category = case_when(
    predicted_prob <= percentile_33 ~ "Alto riesgo de no potabilidad",
    predicted_prob > percentile_33 & predicted_prob <= percentile_66 ~ "Moderado",
    predicted_prob > percentile_66 ~ "Bajo riesgo de no potabilidad"
  ))

# Evaluación del desempeño del modelo: matriz de confusión y precisión
predicted_classes <- ifelse(test_data$predicted_prob > 0.5, 1, 0)
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
ggplot(test_data, aes(x = predicted_prob, fill = Risk_Category)) +
  geom_histogram(binwidth = 0.05) +
  labs(title = "Distribución de la probabilidad de potabilidad en el conjunto de prueba", x = "Probabilidad de Potabilidad", y = "Frecuencia") +
  theme_minimal()

# curva ROC y AUC para evaluar la capacidad del modelo de distinguir entre clases
roc_curve <- roc(test_data$Potability, test_data$predicted_prob)
plot(roc_curve, main = "Curva ROC para el conjunto de prueba")
auc_value <- auc(roc_curve)
print(paste("AUC del modelo en el conjunto de prueba:", auc_value))

# El puntaje F1 para mirar la efectividad del modleo en clasificar correctamente
f1 <- f1_score(as.factor(test_data$Potability), as.factor(predicted_classes))
print(paste("F1 Score en el conjunto de prueba:", f1))
