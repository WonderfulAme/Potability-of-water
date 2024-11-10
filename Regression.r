# Cargar las librerías necesarias
library(dplyr)
library(ggplot2)
library(MASS)
library(lava)
library(caret)
library(pROC) 
library(Metrics)

# Cambiar el camino al archivo dependiendo de donde lo guardaras
water_data <- read.csv('water_potability.csv') 

# Transformación de la variable "Solids" (raíz cuadrada) para cumplir la normalidad
water_data$Solids <- sqrt(water_data$Solids)

# Imputación de valores faltantes con el promedio de cada columna
water_data <- water_data %>%
  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .)))

# Normalización de las variables numéricas en el rango [0, 1]
preprocess_params <- preProcess(water_data[, sapply(water_data, is.numeric)], method = c("range"))
water_data_normalized <- predict(preprocess_params, water_data)

# Asegurarse de que la columna Potability esté presente en water_data_normalized
water_data_normalized$Potability <- water_data$Potability

# Aplicación de PCA solo a las variables predictoras (excluyendo la variable de respuesta 'Potability')
predictors <- water_data_normalized[, !names(water_data_normalized) %in% "Potability"]
pca_result <- prcomp(predictors, center = TRUE, scale. = TRUE)

# Ver el porcentaje de varianza explicada por cada componente principal
summary(pca_result)

# Seleccionar los componentes que expliquen la mayoría de la varianza (por ejemplo, el 90%)
var_explained <- cumsum(pca_result$sdev^2) / sum(pca_result$sdev^2)
selected_components <- which(var_explained >= 0.90)[1]  # Seleccionar hasta el componente que alcance el 90% de varianza

# Crear un nuevo conjunto de datos con los componentes seleccionados
pca_data <- data.frame(pca_result$x[, 1:selected_components])
pca_data$Potability <- water_data_normalized$Potability  # Añadir la variable de respuesta al conjunto de datos con PCA

# División de los datos en conjuntos de entrenamiento, prueba y validación
set.seed(123)
trainIndex <- createDataPartition(pca_data$Potability, p = 0.6, list = FALSE)
train_data <- pca_data[trainIndex, ]
temp_data <- pca_data[-trainIndex, ]
# División entre prueba y validación (50-50 de los datos restantes)
testIndex <- createDataPartition(temp_data$Potability, p = 0.5, list = FALSE)
test_data <- temp_data[testIndex, ]
validation_data <- temp_data[-testIndex, ]

# Ajuste del modelo de regresión logística en el conjunto de entrenamiento
model <- glm(Potability ~ ., data = train_data, family = binomial(link = "logit"))

# Resumen del modelo para evaluar los coeficientes de los componentes principales
summary(model)

# Calcular las probabilidades utilizando predict() en lugar de una función personalizada
train_data$Probability_of_Potability <- predict(model, type = "response")

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

# Visualización de la distribución de las probabilidades de potabilidad
ggplot(water_potability, aes(x = Probability_of_Potability, fill = as.factor(Potability))) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribución de la Probabilidad de Potabilidad", 
       x = "Probabilidad de Potabilidad", 
       y = "Densidad", 
       fill = "Clase Real") +
  theme_minimal() +
  scale_fill_manual(values = c("0" = "red", "1" = "blue"), labels = c("No potable", "Potable"))


# Gráfico mejorado de la curva ROC
plot(roc_curve, col = "#1f77b4", lwd = 2, main = "Curva ROC para el Conjunto de Prueba")
abline(a = 0, b = 1, col = "red", lty = 2) # Línea diagonal de referencia
legend("bottomright", legend = paste("AUC =", round(auc_value, 4)), col = "#1f77b4", lwd = 2, box.lty = 0)

# Guardar la distribución de probabilidad de potabilidad
ggsave("distribucion_probabilidad_potabilidad.png", width = 8, height = 5)

# Guardar la curva ROC
png("curva_roc.png", width = 800, height = 600)
plot(roc_curve, col = "#1f77b4", lwd = 2, main = "Curva ROC para el Conjunto de Prueba")
abline(a = 0, b = 1, col = "red", lty = 2) # Línea diagonal de referencia
legend("bottomright", legend = paste("AUC =", round(auc_value, 4)), col = "#1f77b4", lwd = 2, box.lty = 0)
dev.off()

